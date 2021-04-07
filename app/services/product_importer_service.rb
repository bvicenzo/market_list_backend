# frozen_string_literal: true

class ProductImporterService
  attr_reader :code

  def initialize(code:)
    @code = code
  end

  def run
    response = product_client.fetch_by_gtin(code: code)

    return build_failure_for(response) unless response[:success]

    product_data = response[:product_data]
    product = product_for(product_data)

    imported_product = product.nil? ? create_product_for(product_data) : update_product_for(product_data)

    if imported_product.errors.blank?
      { success: true, product: imported_product }
    else
      { success: false }
    end
  end

  private

  def product_client
    @product_client ||= Clients::BlueSoft::Cosmos::Product.new
  end

  def build_failure_for(response)
    failure = { success: false }

    case response
    in { error: { kind: :server_error } } | { error: { code: :network_error } }
      failure.merge!(retryable: true, retry_in: 1.hour)
    in { error: { code: :too_many_requests } }
      failure.merge!(retryable: true, retry_in: 1.day)
    else
      failure.merge!(retryable: false)
    end

    failure
  end

  def product_for(product_data)
    product_numbers = product_data[:gtins].pluck(:gtin)

    Product.joins(:global_trade_item_numbers).find_by(global_trade_item_numbers: { number: product_numbers })
  end

  def create_product_for(product_data)
    product = initialize_product_for(product_data)
    assing_global_trade_numbers_for(product, product_data[:gtins])

    product.save

    product
  end

  def update_product_for(_product_data); end

  def initialize_product_for(product_data)
    Product.new(
      name: product_data[:description],
      thumbnail: product_data[:thumbnail],
      price: product_data[:price],
      avg_price: product_data[:avg_price],
      max_price: product_data[:max_price],
      min_price: product_data[:min_price],
      origin: product_data[:origin],
      barcode_image: product_data[:barcode_image]
    )
  end

  def assing_global_trade_numbers_for(product, global_trade_item_numbers_data)
    global_trade_item_numbers_data.each do |global_trade_item_number_data|
      commercial_unity_data = global_trade_item_number_data[:commercial_unit]
      product.global_trade_item_numbers.build(
        number: global_trade_item_number_data[:gtin],
        type_packaging: commercial_unity_data[:type_packaging],
        quantity_packaging: commercial_unity_data[:quantity_packaging],
        ballast: commercial_unity_data[:ballast],
        layer: commercial_unity_data[:layer]
      )
    end
  end
end

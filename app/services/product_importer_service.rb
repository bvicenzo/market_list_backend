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

    imported_product = product.nil? ? create_product_for(product_data) : update_product_for(product, product_data)

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
    product.brand = build_brand_for(product_data.fetch(:brand, nil))
    product.global_product_classification = build_global_product_classification_for(product_data.fetch(:gpc, nil))
    product.mercosul_common_nomenclature = build_mercosul_common_nomenclature_for(product_data.fetch(:ncm, nil))
    product.specification_code_for_tax_substitution = build_specification_code_for_tax_substitution_for(
      product_data.fetch(:cest, nil)
    )

    product.save

    product
  end

  def update_product_for(product, product_data)
    product.attributes = {
      name: product_data[:description],
      thumbnail: product_data[:thumbnail],
      price: product_data[:price],
      avg_price: product_data[:avg_price],
      max_price: product_data[:max_price],
      min_price: product_data[:min_price],
      origin: product_data[:origin],
      barcode_image: product_data[:barcode_image]
    }

    product.save

    product
  end

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

  def build_brand_for(brand_data)
    return nil unless brand_data

    brand = Brand.find_or_initialize_by(raw_name: brand_data[:name])
    brand.name = brand_data[:name]
    brand.picture_url = brand_data[:picture]

    brand
  end

  def build_global_product_classification_for(global_product_classification_data)
    return nil unless global_product_classification_data

    global_product_classification = GlobalProductClassification
      .find_or_initialize_by(code: global_product_classification_data[:code])

    received_description = global_product_classification_data[:description]
    global_product_classification.description = received_description if received_description.present?

    global_product_classification
  end

  def build_mercosul_common_nomenclature_for(mercosul_common_nomenclature_data)
    return nil unless mercosul_common_nomenclature_data

    mercosul_common_nomenclature = MercosulCommonNomenclature
      .find_or_initialize_by(code: mercosul_common_nomenclature_data[:code])

    received_description = mercosul_common_nomenclature_data[:description]
    mercosul_common_nomenclature.description = received_description if received_description.present?
    mercosul_common_nomenclature.full_description = mercosul_common_nomenclature_data[:full_description]

    mercosul_common_nomenclature
  end

  def build_specification_code_for_tax_substitution_for(specification_code_for_tax_substitution_data)
    return nil unless specification_code_for_tax_substitution_data

    specification_code_for_tax_substitution = SpecificationCodeForTaxSubstitution
      .find_or_initialize_by(code: specification_code_for_tax_substitution_data[:code])

    received_description = specification_code_for_tax_substitution_data[:description]
    specification_code_for_tax_substitution.description = received_description if received_description.present?

    specification_code_for_tax_substitution
  end
end

# frozen_string_literal: true

module Clients
  module BlueSoft
    module Cosmos
      # Implements a bluesoft product fetching by following their API docs:
      # https://cosmos.bluesoft.com.br/api
      class Product
        PATH = '/gtins/%<code>s.json'

        def fetch_by_gtin(code:)
          response = connection.get(path_for(code))

          response.success? ? success_message_for(response) : failure_message_for(response)
        rescue Faraday::ConnectionFailed => error
          exception_response_for(error)
        end

        private

        def path_for(code)
          format(PATH, code: code)
        end

        def connection
          @connection ||= Faraday.new(url) do |req|
            req.headers['Content-Type'] = 'application/json'
            req.headers['X-Cosmos-Token'] = ENV.fetch('BLUESOFT_COSMOS_API_TOKEN')
            req.headers['Accept-Encoding'] = 'utf-8'
          end
        end

        def url
          @url ||= ENV.fetch('BLUESOFT_COSMOS_PRODUCT_API_URL')
        end

        def success_message_for(response)
          { success: true, product_data: parsed_body_for(response.body) }
        end

        def failure_message_for(response)
          error_family = if response.status.between?(500, 599)
                           :server_error
                         elsif response.status.between?(400, 499)
                           :client_error
                         end

          { success: false, error: { code: error_family, message: parsed_body_for(response.body) } }
        end

        def exception_response_for(error)
          { success: false, error: { code: :network_error, message: error.message } }
        end

        def parsed_body_for(body)
          JSON.parse(body, symbolize_names: true)
        end
      end
    end
  end
end

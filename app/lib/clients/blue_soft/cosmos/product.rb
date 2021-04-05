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
          {
            success: false,
            error: {
              code: code_for(response.status),
              kind: response_kind_for(response.status),
              message: parsed_body_for(response.body)
            }
          }
        end

        def exception_response_for(error)
          { success: false, error: { code: :network_error, kind: :connection_failed, message: error.message } }
        end

        def parsed_body_for(body)
          JSON.parse(body, symbolize_names: true)
        end

        # Private
        # Generates a HTTParty response message from a Net::HTTPRespoonse Class
        # Examples:
        #
        # response_type(Net::HTTPOK)
        # # => "OK"
        #
        # response_type(Net::HTTPUnprocessableEntity)
        # # => "Unprocessable Entity"
        def code_for(response_status)
          response_class_for(response_status)
            .to_s
            .delete_prefix('Net::HTTP')
            .gsub(/([A-Z]+)([A-Z][a-z])/, '\1 \2')
            .gsub(/([a-z])([A-Z])/, '\1 \2')
            .remove(' ')
            .underscore
            .to_sym
        end

        # Private
        # Get an HTTP status error name for a status code
        #
        # Ex: 400
        # # => "Net:HTTPBadRequest"
        def response_class_for(response_status)
          Net::HTTPResponse::CODE_TO_OBJ[response_status.to_s].to_s
        end

        def response_kind_for(response_status)
          if response_status.between?(500, 599)
            :server_error
          elsif response_status.between?(400, 499)
            :client_error
          end
        end
      end
    end
  end
end

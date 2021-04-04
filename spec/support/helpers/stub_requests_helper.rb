# frozen_string_literal: true

module StubRequestsHelper
  def allow_get_request(options = {}, to:)
    options[:headers] = (options[:headers] || {}).tap do |headers|
      headers['Content-Type'] ||= 'application/json'
      headers['X-Cosmos-Token'] ||= ENV.fetch('BLUESOFT_COSMOS_API_TOKEN')
      headers['Accept-Encoding'] ||= 'utf-8'
    end

    stub_request(:get, to).with(options.compact)
  end

  def stub_get(options = {}, to:, response_status: 200, response_body: {})
    allow_get_request(options, to: to)
      .to_return(
        status: response_status,
        body: response_body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end
end

RSpec.configure do |config|
  config.include StubRequestsHelper
end

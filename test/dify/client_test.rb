# frozen_string_literal: true

require "test_helper"
require "webmock/minitest"
require "json"
require "dify/client"

class DifyClientTest < Minitest::Test
  def setup
    @api_key = "YOUR_API_KEY"
    @client = DifyClient.new(@api_key)
  end

  def test_update_api_key
    new_api_key = "NEW_API_KEY"

    @client.update_api_key(new_api_key)

    assert_equal new_api_key, @client.instance_variable_get(:@api_key)
  end

  def test_get_application_parameters
    user = "USER_ID"
    response_body = { "parameters" => [{ "name" => "test", "value" => "test_value" }] }

    stub_request(:get, "https://api.dify.ai/v1/parameters?user=USER_ID")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer YOUR_API_KEY",
          "Content-Type" => "application/json",
          "User-Agent" => "Ruby"
        }
      )
      .to_return(status: 200, body: response_body.to_json, headers: {})

    response = @client.get_application_parameters(user)

    assert_equal 200, response.code.to_i
    assert_equal response_body, JSON.parse(response.body)
  end
end

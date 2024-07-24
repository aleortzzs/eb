require 'uri'
require 'net/http'
require 'json'

class EasyBroker
  BASE_URL = 'https://api.stagingeb.com/v1/properties'.freeze
  API_KEY = 'l7u502p8v46ba3ppgvj5y2aad50lb9'.freeze

  def initialize
    @uri = URI(BASE_URL)
  end

  def fetch_property_titles
    response = make_request
    if response.is_a?(Net::HTTPSuccess)
      begin
        data = JSON.parse(response.body)
        if data['content'].is_a?(Array)
          data['content'].map { |property| property['title'] }
        else
          raise "Unexpected JSON structure: #{data.inspect}"
        end
      rescue JSON::ParserError => e
        raise "Error parsing JSON response: #{e.message}"
      end
    else
      raise "Error fetching properties: #{response.message}"
    end
  end

  private

  def make_request
    uri_with_params = URI(BASE_URL)
    uri_with_params.query = URI.encode_www_form(page: 1, limit: 20)
    
    http = Net::HTTP.new(uri_with_params.host, uri_with_params.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri_with_params)
    request["accept"] = 'application/json'
    request["X-Authorization"] = API_KEY

    http.request(request)
  end
end

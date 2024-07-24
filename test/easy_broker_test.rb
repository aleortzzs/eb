require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../lib/easy_broker'

class EasyBrokerTest < Minitest::Test
  def setup
    @eb = EasyBroker.new
  end

  def test_fetch_property_titles
    stub_request(:get, "https://api.stagingeb.com/v1/properties?page=1&limit=20")
      .with(
        headers: { 'Accept' => 'application/json', 'X-Authorization' => 'l7u502p8v46ba3ppgvj5y2aad50lb9'}
      ).to_return(
        status: 200,
        body: '{"content":[{"title":"Casa en Venta Amorada en Santiago Nuevo Leon"},{"title":"Beautiful property in Condesa."}]}',
        headers: {}
      )

    titles = @eb.fetch_property_titles
    assert_equal ["Casa en Venta Amorada en Santiago Nuevo Leon", "Beautiful property in Condesa."], titles
  end
end

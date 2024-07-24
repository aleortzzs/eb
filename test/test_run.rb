require_relative '../lib/easy_broker'

eb = EasyBroker.new
titles = eb.fetch_property_titles
puts "Property Titles: #{titles}"

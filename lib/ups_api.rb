



# EXAMPLES:

# # Find out how much it'll be.
# ups = ActiveShipping::UPS.new(:login => 'auntjudy', :password => 'secret', :key => 'xml-access-key')
# response = ups.find_rates(origin, destination, packages)

# ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
# # => [["UPS Standard", 3936],
# #     ["UPS Worldwide Expedited", 8682],
# #     ["UPS Saver", 9348],
# #     ["UPS Express", 9702],
# #     ["UPS Worldwide Express Plus", 14502]]

# # Check out USPS for comparison...
# usps = ActiveShipping::USPS.new(:login => 'developer-key')
# response = usps.find_rates(origin, destination, packages)

# usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
# # => [["USPS Priority Mail International", 4110],
# #     ["USPS Express Mail International (EMS)", 5750],
# #     ["USPS Global Express Guaranteed Non-Document Non-Rectangular", 9400],
# #     ["USPS GXG Envelopes", 9400],
# #     ["USPS Global Express Guaranteed Non-Document Rectangular", 9400],
# #     ["USPS Global Express Guaranteed", 9400]]
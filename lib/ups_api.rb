class UpsApi

  def initialize
    @ups = ActiveShipping::UPS.new(
      :login => ENV['UPS_LOGIN'],
      :password => ENV['UPS_PASSWORD'],
      :key => ENV['UPS_KEY'])
  end

  def calc_ups_options(origin, destination, packages)
    response = @ups.find_rates(origin, destination, packages)

    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, normalize_rate(rate.price)]}
  end

  def normalize_rate(rate)
    rate/100.00
  end

  # ActiveShipping gem Carrier.create_shipment(origin, destination, packages, options = {})
  def get_tracking(origin, destination, packages)
    response = @ups.create_shipment(origin, destination, packages)
  end
end


# EXAMPLE:

# ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
# # => [["UPS Standard", 3936],
# #     ["UPS Worldwide Expedited", 8682],
# #     ["UPS Saver", 9348],
# #     ["UPS Express", 9702],
# #     ["UPS Worldwide Express Plus", 14502]]

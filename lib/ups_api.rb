class UpsApi
  
  def initialize
    @ups = ActiveShipping::UPS.new(
      :login => ENV['ACTIVESHIPPING_UPS_LOGIN'], 
      :password => ENV['ACTIVESHIPPING_UPS_PASSWORD'], 
      :key => ENV['ACTIVESHIPPING_UPS_KEY'])
  end

  def calc_ups_options(origin, destination, package)
    response = @ups.find_rates(origin, destination, package)

    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  end
end


# EXAMPLE:

# ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
# # => [["UPS Standard", 3936],
# #     ["UPS Worldwide Expedited", 8682],
# #     ["UPS Saver", 9348],
# #     ["UPS Express", 9702],
# #     ["UPS Worldwide Express Plus", 14502]]

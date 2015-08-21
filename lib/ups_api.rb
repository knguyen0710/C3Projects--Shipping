class UpsApi

  def initialize
    @ups = ActiveShipping::UPS.new(
      :login => ENV['UPS_LOGIN'],
      :password => ENV['UPS_PASSWORD'],
      :key => ENV['UPS_KEY'])
  end

  def calc_ups_options(origin, destination, packages)
    response = @ups.find_rates(origin, destination, packages)
    
    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, normalize_rate(rate.price), rate.delivery_date]}
  end

  def normalize_rate(rate)
    rate/100.00
  end

end

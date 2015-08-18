class FedexApi
  attr_reader :fedex

  def initialize
    @fedex = ActiveShipping::FedEx.new(login: ENV['FEDEX_LOGIN'],
                                    password: ENV['FEDEX_PASSWORD'],
                                    key: ENV['FEDEX_TEST_KEY'],
                                    account: ENV['FEDEX_ACCOUNT'],
                                    test: true)
  end

  def fedex_rates(origin, destination, packages)
    response = @fedex.find_rates(origin, destination, packages)
    fedex_response = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, normalize_rate(rate.price)]}
  end

  def normalize_rate(rate)
    rate/100.00
  end
end

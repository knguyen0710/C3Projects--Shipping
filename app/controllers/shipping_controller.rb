class ShippingController < ApplicationController

  before_action :origin, only: :calc_shipping_options

  def calc_shipping_options(weight, dimensions, units, country, state, city, zip)

    # create an ActiveShipping package and destination to be used with gem
    package = new_package(weight, dimensions, units)
    destination = new_destination(country, state, city, zip)

    # call UPS API with params (.rb file) (pass in package, destination and @origin)
    ups_options =

    # call FedEx API with params (.rb file) (pass in package, destination and @origin)
    fedex_options = fedex_rates(origin, destination, package)

    # concatenate the two shipping provider arrays into one array of all the shipping options
    shipping_options = ups_options + fedex_options

    # turn this into a json object to send back to bEtsy app

    # EXAMPLE from class:
    unless shipping_options.empty?
      render json: shipping_options.as_json(except: [:created_at, :updated_at])
    else
      render json: {}, status: 204
    end

  end

  # def log_completed_shipment
    # another API call from bEtsy to our API to log which shipping method/cost, etc. they checked out with
  # end

##################################################
private

  def new_package(weight, dimensions, units)
    ActiveShipping::Package.new(weight, dimensions, units)
  end

  def new_destination(country, state, city, zip)
    ActiveShipping::Location.new( :country => country,
                                  :state => state,
                                  :city => city,
                                  :zip => zip)
  end

  def origin
    @origin = ActiveShipping::Location.new( :country => "US",
                                  :state => "WA",
                                  :city => "Seattle",
                                  :zip => "98109")
  end

end

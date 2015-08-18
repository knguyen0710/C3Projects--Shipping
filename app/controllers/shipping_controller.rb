
class ShippingController < ApplicationController

  before_action :origin, only: :calc_rates

  # where the route goes from the API call
  def calc_rates
    destination = new_destination(params[:country], params[:state], params[:city], params[:zip])
    package = new_package(params[:weight], params[:dimensions], params[:units])

    calc_shipping_options(@origin, destination, package)
  end

  # def log_completed_shipment
    # another API call from bEtsy to our API to log which shipping method/cost, etc. they checked out with
  # end

##################################################
private

  def new_destination(country, state, city, zip)
    ActiveShipping::Location.new( :country => country,
                                  :state => state,
                                  :city => city,
                                  :zip => zip)

            # What it returns for a location...
                # => Seattle, WA, 98109
                # United States
  end

  def new_package(weight, dimensions, units)
    ActiveShipping::Package.new(weight, dimensions, units)

            #  What a new package looks like...
                # #<ActiveShipping::Package:0x007fb1a61e3278
                #  @currency=nil,
                #  @cylinder=false,
                #  @dimensions=[#<Quantified::Length: 4.5 inches>, #<Quantified::Length: 10 inches>, #<Quantified::Length: 15 inches>],
                #  @dimensions_unit_system=:imperial,
                #  @gift=false,
                #  @options={:units=>:imperial},
                #  @oversized=false,
                #  @unpackaged=false,
                #  @value=nil,
                #  @weight=#<Quantified::Mass: 7.5 ounces>,
                #  @weight_unit_system=:imperial>
  end

  def origin
    @origin = ActiveShipping::Location.new( :country => "US",
                                  :state => "WA",
                                  :city => "Seattle",
                                  :zip => "98109")
  end

  def calc_shipping_options(origin, destination, package)
    # call UPS API with params (.rb file) (pass in package, destination and @origin)
    ups_options = UpsApi.new.calc_ups_options(origin, destination, package)

    # call FedEx API with params (.rb file) (pass in package, destination and @origin)
    fedex_options = 

    # concatenate the two shipping provider arrays into one array of all the shipping options
    shipping_options = ups_options + fedex_options

    # turn this into a json object to send back to bEtsy app

    # EXAMPLE from class:
    # unless matches.empty?
    #   render json: matches.as_json(except: [:created_at, :updated_at])
    # else
    #   render json: {}, status: 204
    # end

  end

end

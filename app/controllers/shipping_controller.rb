class ShippingController < ApplicationController

  # where the route goes from the API call
  def calc_rates
    # http://localhost:3000/shipping?state=UT&city=park%20city&zip=98109&packages[][length]=2&packages[][width]=2&packages[][length]=3&packages[][width]=3
    # packages[0][length]=2&packages[0][width]=2

    # http://localhost:3001/shipping?state=WA&city=seattle&zip=98101&o_state=WA&o_city=seattle&o_zip=98101&packages[][length]=12.0&packages[][width]=10.0&packages[][height]=2.0&packages[][weight]=1.0&packages[][length]=12.0&packages[][width]=10.0&packages[][height]=2.0&packages[][weight]=1.0&packages[][length]=12.0&packages[][width]=10.0&packages[][height]=2.0&packages[][weight]=1.0

    origin = origin(params[:o_state], params[:o_city], params[:o_zip])

    destination = new_destination(params[:state], params[:city], params[:zip])

    all_packages = new_package(params[:packages])

    shipping_options = calc_shipping_options(origin, destination, all_packages)
    # turn this into a json object to send back to bEtsy app
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

  def new_destination(state, city, zip)
    ActiveShipping::Location.new( :country => 'US',
                                  :state => state,
                                  :city => city,
                                  :zip => zip)

            # What it returns for a location...
                # => Seattle, WA, 98109
                # United States
  end

  def new_package(packages)
    all_packages = []
    packages.each do |p|
      all_packages << ActiveShipping::Package.new(p[:weight].to_f, [p[:length].to_i, p[:width].to_i, p[:height].to_i], :units => :imperial)

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

    return all_packages
  end

  def origin(state, city, zip)
    ActiveShipping::Location.new( :country => "US",
                                  :state => state,
                                  :city => city,
                                  :zip => zip)
  end

  def calc_shipping_options(origin, destination, packages)
    ups_options = UpsApi.new.calc_ups_options(origin, destination, packages)
    fedex_options = FedexApi.new.fedex_rates(origin, destination, packages)

    shipping_options = ups_options + fedex_options
  end

end

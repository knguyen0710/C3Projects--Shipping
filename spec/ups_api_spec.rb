require 'rails_helper'
require 'ups_api'
require 'support/vcr_setup'

RSpec.describe UpsApi do
  describe "calc_ups_options" do
    let(:ups_api) { UpsApi.new }
    let(:origin) { ActiveShipping::Location.new( :country => 'US',
                                    :state => "UT",
                                    :city => "Park City",
                                    :zip => 84098)
                  }
    let(:destination) { ActiveShipping::Location.new( :country => 'US',
                                    :state => "WA",
                                    :city => "Seattle",
                                    :zip => 98109 )
                  }
    let(:package1) { ActiveShipping::Package.new(10, [8, 11, 2], :units => :imperial) }
    let(:package2) { ActiveShipping::Package.new(10, [8, 11, 2], :units => :imperial) }
    
    it "finds ups shipping options" do
      packages = []
      packages << package1 
      packages << package2

      VCR.use_cassette 'ups_api/calc_ups_options' do
        result = ups_api.calc_ups_options(origin, destination, packages)
        expect(result.count).to eq 6
      end
    end
  end
end
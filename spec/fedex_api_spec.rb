require 'rails_helper'
require 'fedex_api'
require 'support/vcr_setup'

RSpec.describe FedexApi do
  describe "fedex_rates" do
    let(:fedex_api) { FedexApi.new }
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
    
    it "finds fedex shipping rates" do
      packages = []
      packages << package1 
      packages << package2

      VCR.use_cassette 'fedex_api/fedex_rates' do
        result = fedex_api.fedex_rates(origin, destination, packages)
        expect(result.count).to eq 9
      end
    end
  end
end
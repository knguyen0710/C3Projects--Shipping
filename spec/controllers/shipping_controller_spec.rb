require 'rails_helper'

RSpec.describe ShippingController, type: :controller do

  describe "GET #calc_rates" do
    context "valid address" do
      before :each do
        
        get :calc_rates, state: "UT", city: "Park City", zip: 84098, o_state: "WA", o_city: "Seattle", o_zip: 98109, packages: [{"length"=>"2", "width"=>"2", "height"=>"2", "weight"=>"2"}]
      end

      it "is successful" do
        expect(response.response_code).to eq 200
      end

      it "renders a json object" do
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end

    # context "invalid address" do
    #   it "renders an empty json object" do
    #   end
    # end
  end

end

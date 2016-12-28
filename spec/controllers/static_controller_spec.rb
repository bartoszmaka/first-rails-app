require 'rails_helper'

RSpec.describe StaticController, type: :controller do

  describe "GET #denied" do
    it "returns http success" do
      get :denied
      expect(response).to have_http_status(:success)
    end
  end

end

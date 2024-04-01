# spec/requests/teas_spec.rb
require "rails_helper"

RSpec.describe "Teas", type: :request do
  describe "GET /teas/:id" do
    it "returns the tea" do
      tea = Tea.create!(title: "Green Tea", description: "Green tea is lighter than Black Tea", temperature: 180, brew_time: 5)

      get api_v1_tea_path(tea)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(tea.title)
      expect(response.body).to include(tea.description)
      expect(response.body).to include(tea.temperature.to_s)
      expect(response.body).to include(tea.brew_time.to_s)
    end
  end

  describe "POST /teas" do
    it "HAPPY PATH: creates a new tea" do
      tea_params = { tea: { title: "Green Tea", description: "Green tea is lighter than Black Tea", temperature: 180, brew_time: 5 } }

      post api_v1_teas_path, params: tea_params

      expect(response).to have_http_status(:created)
      expect(Tea.count).to eq(1)
      expect(response.body).to include("Green Tea")
      expect(response.body).to include("Green tea is lighter than Black Tea")
      expect(response.body).to include("180")
      expect(response.body).to include("5")
    end
  end
end
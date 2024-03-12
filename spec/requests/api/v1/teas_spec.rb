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
end
require 'rails_helper'

RSpec.describe "DeviseUsers", type: :request do
    describe "saves users" do
      it 'Passes Devies Requirments To Save' do
        user = FactoryBot.create(:user)
        expect(user.save).to eq true
        expect(user.email).to eq(user.email)
        expect( ActionMailer::Base.deliveries.count ).to eq(1)
    end
  end
end

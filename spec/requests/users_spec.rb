require 'rails_helper'

RSpec.describe "DeviseUsers", type: :request do
    describe "saves users" do
      it 'Passes Devies Requirments To Save' do
        user = FactoryBot.create(:user)
        expect(user.save).to eq true
        expect(user.email).to eq(user.email)
        expect { post :create, :new_user_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events', type: :request do
  describe 'get events_path' do
    it 'renders the index view', focus: true do
      FactoryBot.create_list(:event, 10)
      get events_path
      expect(response).to render_template(:index)
    end
  end
end

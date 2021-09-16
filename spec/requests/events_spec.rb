# frozen_string_literal: true

require 'rails_helper'
require 'ice_cube'
require 'active_support/time'

RSpec.describe 'Events', type: :request do
  describe 'get events_path' do
    it 'renders the index view' do
      FactoryBot.create_list(:event, 10)
      get events_path
      expect(response).to render_template(:index)
    end
  end
  describe 'get event_path' do
    it 'renders the :show template' do
      event = FactoryBot.create(:event)
      get event_path(id: event.id)
      expect(response).to render_template(:show)
    end
    it 'redirects to the index path if the event id is invalid' do
      get event_path(id: 5000) # an ID that doesn't exist
      expect(response).to redirect_to events_path
    end
  end
  describe 'get new_event_path' do
    it 'renders the :new template' do
      get new_event_path
      expect(response).to render_template(:new)
    end
  end
  describe 'get edit_event_path' do
    it 'renders the :edit template' do
      event = FactoryBot.create(:event)
      get edit_event_path(id: event.id)
      expect(response).to render_template(:edit)
    end
  end
  describe 'post events_path with valid data' do
    it 'saves a new entry and redirects to the show path for the entry' do
      event_attributes = FactoryBot.attributes_for(:event)
      expect do
        post events_path, params: { event: event_attributes }
      end.to change(Event, :count)
      expect(response).to redirect_to event_path(id: Event.last.id)
    end
  end
  describe 'post events_path with invalid data' do
    it 'does not save a new entry or redirect' do
      event_attributes = FactoryBot.attributes_for(:event)
      event_attributes.delete(:event_location)
      expect do
        post events_path, params: { event: event_attributes }
      end.to_not change(Event, :count)
      expect(response).to render_template(:new)
    end
  end
  describe 'put event_path with valid data' do
    it 'updates an entry and redirects to the show path for the event' do
      event = FactoryBot.create(:event)
      put event_path(event.id), params: { event: { description: 'Birthday Party' } }
      event.reload
      expect(event.description).to eq('Birthday Party')
      expect(response).to redirect_to event_path(id: event.id)
    end
  end
  describe 'put event_path with invalid data' do
    it 'does not update the event record or redirect' do
      event = FactoryBot.create(:event)
      put event_path(event.id), params: { event: { description: '' } }
      event.reload
      expect(event.description).not_to eq('')
      expect(response).to render_template(:edit)
    end
  end
  describe 'delete an event record' do
    it 'deletes an event record' do
      event = FactoryBot.create(:event)
      event.destroy
      expect do
        get events_path
      end.to_not change(Event, :count)
      expect(response).to render_template(:index)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MembersControllers', type: :request do
  describe 'get members_path' do
    it 'renders the index view' do
      FactoryBot.create_list(:member, 10)
      get members_path
      expect(response).to render_template(:index)
    end
  end
  describe 'get member_path' do
    it 'renders the :show template' do
      member = FactoryBot.create(:member)
      get member_path(id: member.id)
      expect(response).to render_template(:show)
    end
    it 'redirects to the index path if the member id is invalid' do
      get member_path(id: 5000) # an ID that doesn't exist
      expect(response).to redirect_to members_path
    end
  end
  describe 'get new_member_path' do
    it 'renders the :new template' do
      get '/members/new'
      expect(response).to render_template(:new)
    end
  end
  describe 'get edit_member_path' do
    it 'renders the :edit template' do
      member = FactoryBot.create(:member)
      get edit_member_path(id: member.id)
      expect(response).to render_template(:edit)
    end
  end
  describe 'post members_path with valid data' do
    it 'saves a new entry and redirects to the show path for the entry' do
      member_attributes = FactoryBot.attributes_for(:member)
      expect do
        post members_path, params: { member: member_attributes }
      end.to change(Member, :count)
      expect(response).to redirect_to member_path(id: Member.last.id)
    end
  end
  describe 'post members_path with invalid data' do
    it 'does not save a new entry or redirect' do
      member_attributes = FactoryBot.attributes_for(:member)
      member_attributes.delete(:first_name)
      expect do
        post members_path, params: { member: member_attributes }
      end.to_not change(Member, :count)
      expect(response).to render_template(:new)
    end
  end
  describe 'put member_path with valid data' do
    it 'updates an entry and redirects to the show path for the member' do
      member = FactoryBot.create(:member)
      put member_path(member.id), params: { member: { phone: '1234567890' } }
      member.reload
      expect(member.phone).to eq('1234567890')
      expect(response).to redirect_to member_path(id: member.id)
    end
  end
  describe 'put member_path with invalid data' do
    it 'does not update the member record or redirect' do
      member = FactoryBot.create(:member)
      put member_path(member.id), params: { member: { phone: '123' } }
      member.reload
      expect(member.phone).not_to eq('123')
      expect(response).to render_template(:edit)
    end
  end
  describe 'delete a member record' do
    it 'deletes a member record' do
      member = FactoryBot.create(:member)
      delete member_path(member.id)
      # customer.reload
      # expect(customer.id).to change (Customer.count)
      expect(response).to redirect_to members_path
    end
  end
end

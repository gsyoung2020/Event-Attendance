require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'Mailer' do
    user = FactoryBot.create(:user)
    let(:mail) {

    it 'renders the subject' do
      expect(mail.subject).to eq('You got a new order!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq('eattendace@gmail.com')
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['eattendace@gmail.com'])
    end
    end
  end
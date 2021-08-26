# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'eattendace@gmail.com'
  layout 'mailer'
end

# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def new_user_email
    # Set up a temporary user for the preview
    user = User.new(email: 'joe@gmail.com')

    UserMailer.with(user: user).new_user_email
  end
end

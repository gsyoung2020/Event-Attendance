require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "new user email" do
    # Set up an user based on the fixture
    user = users(:one)

    # Set up an email using the user contents
    email = UserMailer.with(user: user).new_user_email

    # Check if the email is sent
    assert_emails 1 do
      email.deliver_now
    end

    # Check the contents are correct
    assert_equal ['eattendace@gmail.com'], email.from
    assert_equal ['eattendace@gmail.com'], email.to
    assert_equal "You got a new order!", email.subject
    assert_match user.email, email.html_part.body.encoded
    assert_match user.email, email.text_part.body.encoded
  end
end
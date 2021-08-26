class UserMailer < ApplicationMailer
    def new_user_email
        @user = params[:user]
    
        mail(to: 'eattendace@gmail.com', subject: "You got a new order!")
      end
end

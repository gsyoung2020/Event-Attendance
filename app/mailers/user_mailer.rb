class UserMailer < ApplicationMailer
    def new_user_email
        @user = params[:user]
        
        
        mail(to: @user.email, subject: "You got a new order!")
      end
end

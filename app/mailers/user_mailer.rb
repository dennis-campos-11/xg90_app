class UserMailer < ApplicationMailer
  default from: "no-reply@xg90.co"

  def reset_password_email(user)
    @user = user
    @reset_url = "http://localhost:5173/reset_password?token=#{@user.reset_password_token}"
    mail(to: @user.email, subject: "Reset your password")
  end
end
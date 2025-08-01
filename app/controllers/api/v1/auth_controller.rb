class Api::V1::AuthController < ApplicationController
  def sign_in
    user = User.find_by(email: user_params[:email])
    if user&.authenticate(user_params[:password])
      token = jwt_encode(user_id: user.id)
      render json: { token: token, user: user, message: "Welcome back!" }, status: :ok
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def sign_up
    user = User.new(user_params)
    if user.save(context: :reset_password)
      token = jwt_encode(user_id: user.id)
      render json: { token: token, user: user, message: "Welcome, your account was created successfully." }, status: :created
    else
      render json: { errors: user.errors, message: "Oops! We were unable to create your account. Please try again." }, status: :unprocessable_entity
    end
  end

  def forgot_password
    user = User.find_by(email: user_params[:email])
    if user
      user.generate_password_reset_token!
      UserMailer.reset_password_email(user).deliver_later
      render json: { message: "Reset email sent." }, status: :ok
    else
      render json: { message: "Email not found" }, status: :not_found
    end
  end

  def reset_password
    user = User.find_by(reset_password_token: params[:reset_password_token])
    if user&.password_reset_token_valid?
      user.assign_attributes(
        password: user_params[:password],
        password_confirmation: user_params[:password_confirmation]
      )
      if user.save(context: :reset_password)
        user.clear_password_reset_token!
        render json: { message: "Password updated successfully" }, status: :ok
      else
        render json: { errors: user.errors, message: "Error updating password" }, status: :unprocessable_entity
      end
    else
      render json: { message: "Invalid or expired token" }, status: :not_found
    end
  end

  private

  def jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end

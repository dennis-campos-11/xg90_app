class Api::V1::UserSettingsController < ApplicationController
  before_action :authorize_request

  def update
    if @current_user.update(user_settings_params)
      render json: { success: true, user: @current_user }, status: :ok
    else
      render json: { success: false, errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_settings_params
    params.require(:user).permit(:language, :appearance)
  end
end

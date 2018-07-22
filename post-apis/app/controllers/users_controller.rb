class UsersController < ApplicationController
  
  before_action :authenticate_user!

  def show
    render json: {user: {name: current_user.name,email: current_user.email}}
  end
 
  def update
    if current_user.update_attributes(user_params)
      render json: {user: {name: current_user.name,email: current_user.email}}
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:name,:email, :password,:password_confirmation)
  end
end
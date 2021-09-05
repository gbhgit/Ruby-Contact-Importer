# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'User created.'
      redirect_to login_path
    else
      flash[:alert] = 'E-mail alrady in use.'
      redirect_to signup_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end

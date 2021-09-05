# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user, :logged?
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged?
    !!current_user
  end

  def require_user
    unless logged?
      flash[:alert] = 'You must be logged in to perform that action.'
      redirect_to login_path
    end
  end
end

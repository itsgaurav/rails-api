class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
	respond_to :json
	before_action :authenticate_user

	private
	def authenticate_user
    authenticate_or_request_with_http_basic do |username, password|
      user = User.find_by_email(username) 
      if user.valid_password?(password)
        @current_user = user
      else
        render :json => {:msg => "Unable to authorize credentials"}, :status => 401
      end
    end
  end

   def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def current_user
    @current_user ||= super
  end

  def signed_in?
    @current_user.present?
  end
end

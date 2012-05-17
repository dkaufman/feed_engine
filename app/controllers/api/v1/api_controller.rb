class Api::V1::ApiController < ActionController::Base
  before_filter :authenticate_user_token
  respond_to :json

  private
  # current_user needs to become a helper method
  def authenticate_user_token
    @current_user = User.find_by_authentication_token(auth_token)
    unless @current_user
      render :json => "Token is invalid.", status: :unauthorized
    end
  end

  # If wanted to use @current_user = sign_in(auth_user, auth_token) above,
  # then this method applies

  # def auth_user
  #   if Rails.env.development? || Rails.env.test?
  #     headers['Auth-User'] || params[:display_name]
  #   else
  #     headers['Auth-User']
  #   end
  # end

  def auth_token
    if Rails.env.development? || Rails.env.test?
      request.env['HTTP_AUTH_TOKEN'] || params[:token]
    else
      request.env['X-HTTP-AUTHTOKEN'] || params[:token]
    end
  end
end
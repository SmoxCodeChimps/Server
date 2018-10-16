class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def new
  end

  def create
  	user = helpers.authenticate(params[:username], params[:password])
    if !user.nil?
      # Save the user ID in the session so it can be used in
      # subsequent requests
      helpers.login user
      puts(session[:current_user_id] )

    end
  end

  def destroy
    # Remove the user id from the session
    @_current_user = session[:current_user_id] = nil
  end

end

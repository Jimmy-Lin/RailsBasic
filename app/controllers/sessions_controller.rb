class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)

  	if user && user.authenticate(params[:session][:password])
  		#Log user in and redirect to the user's show page
  		log_in user
      if params[:session][:remember_me] == '1'
        remember user
      else
        forget user
      end
  		redirect_back_or user
  	else
  		flash.now[:danger] = "Invalid email/password combination"
  		render 'new'
  	end
  end

  def destroy
  	if is_logged_in?
      log_out
    end
  	redirect_to root_url
  end

end

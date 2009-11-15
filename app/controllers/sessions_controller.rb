class SessionsController < ApplicationController
    
  def new
    
  end

  def create
    self.current_user = User.authenticate(@current_store.id, params[:email], params[:password])
    logger.warn params[:inspect]
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      flash[:notice] = "Logged in successfully"
      if current_user.is_admin?
        redirect_back_or_default('/products')
      else
        redirect_back_or_default("http://#{current_user.store.name}.#{APP_CONFIG[:domain]}")
      end
    else
      flash[:error] = "Your login information is incorrect or you haven't activated your account yet."
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
end

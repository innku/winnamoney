class SessionsController < ApplicationController
  
  before_filter :find_cart
  before_filter :direct_to_default_if_logged_in, :only => [:new]
  
  def new
    render :layout => 'stores'
    virtual_office_action!
  end

  def create
    self.current_user = User.authenticate(@current_store.id, params[:email], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      flash[:notice] = "Logged in successfully"
      virtual_office_action!
      if current_user.is_admin?
        redirect_back_or_default('/products')
      else
        @cart.owner_purchase! if !@cart.owner_purchase?
        user_url = "http://#{current_user.store.name}.#{APP_CONFIG[:domain]}" + stores_path(:index_action => 'referrals')
        redirect_back_or_default(user_url)
      end
    else
      flash.now[:error] = "Your login information is incorrect or you haven't activated your account yet."
      render :action => 'new', :layout => 'stores'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
  
  private
  
  def direct_to_default_if_logged_in
    if @current_user and @current_user.is_admin?
      redirect_to products_path
    elsif @current_user
      virtual_office_action!
      redirect_to "http://#{current_user.store.name}.#{APP_CONFIG[:domain]}" + stores_path(:index_action => 'referrals')
      return false
    end
  end
  
end

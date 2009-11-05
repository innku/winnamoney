# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :find_user

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  protected
  
  def current_store
    subdomain, domain = current_subdomain().split(".")
    @store = Store.find_by_name("subdomain") || Store.first
    @store
  end
  
  def admin_required
    login_required and @current_user.is_admin?
  end
  
  def find_user
    @current_user = current_user
  end
  
  def find_store
    @store = Store.with_subdomain(current_subdomain)
    if @store.nil?
      flash[:error] = "The store you were looking for doesn't exist"
      redirect_to new_session_path
      return false
    elsif @store.inactive? and not (@current_user and @current_user.store == @store)
      flash[:error] = "The store you are looking for is not active yet"
      redirect_to new_session_path
      return false
    end
  end
  
  def find_cart
    unless @current_user and @current_user.is_admin?
      @cart = @store.carts.find_by_id(session[:cart_id])
      session[:cart_id] = @store.carts.create().id if @cart.nil?
    end
  end
  
end

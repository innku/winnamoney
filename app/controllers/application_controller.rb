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
    @current_store = Store.find_by_name("subdomain") || Store.first
    @current_store
  end
  
  def admin_required
    login_required and @current_user.is_admin?
  end
  
  def find_user
    @current_user = current_user
  end
  
  def find_store
    @current_store = Store.with_subdomain(current_subdomain)
    if @current_store.nil?
      flash[:error] = "The store you were looking for doesn't exist"
      redirect_to new_session_path
      return false
    elsif @current_store.inactive? and not (@current_user and @current_user.store == @current_store)
      flash[:error] = "The store you are looking for is not active yet"
      redirect_to new_session_path
      return false
    end
  end
  
  def find_cart
    unless (@current_user and @current_user.is_admin?) or session[:register_user_id]
      @cart = @current_store.carts.find_by_id(session[:cart_id])
      session[:cart_id] = @current_store.carts.create().id if @cart.nil?
    end
  end
  
  def in_register_process?
    not session[:registered_user_id].nil?
  end
  
  
  def clear_register_session
    session[:store_id] = nil
    session[:registered_user_id] = nil
  end
  
  def clear_shopping_session
    session[:cart_id] = nil
  end
  
end

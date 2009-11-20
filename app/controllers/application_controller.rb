# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :find_user, :find_store, :set_locale

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
      redirect_to "http://#{APP_CONFIG[:domain]}?not_found=true"
      return false
    elsif @current_store.inactive? and not (@current_user and @current_user.store == @current_store)
      flash[:error] = "The store you are looking for is not active yet"
      redirect_to "http://#{APP_CONFIG[:domain]}?not_active=true"      
      return false
    end
  end
  
  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale] || @current_store.locale
  end
  
  def store_domain
    "http://#{@current_store.name}.#{APP_CONFIG[:domain]}"
  end
  
  def redirect_and_keep_session(url)
    old_session = session
    redirect_to url
    session = old_session
  end
  
  def find_cart
    unless (@current_user and @current_user.is_admin?) or in_register_process?
      @cart = @current_store.carts.find_by_id(session[:cart_id])
      @cart ||= @current_store.carts.create(:owner_purchase => @current_store.owner?(@current_user))
      session[:cart_id] = @cart.id
    end
  end
  
  def in_register_process?
    !session[:registered_user_id].nil?
  end
  
  def in_shopping_process?
    @cart and !@cart.empty?
  end
  
  def clear_register_session
    session[:registered_store_id] = nil
    session[:registered_user_id] = nil
  end
  
  def clear_shopping_session
    session[:cart_id] = nil
  end
  
  def shopping_action!
    session[:app_action] = 's'
  end
  
  def virtual_office_action!
    session[:app_action] = 'v'
  end
  
  def register_action!
    session[:app_action] = 'r'
  end
  
end

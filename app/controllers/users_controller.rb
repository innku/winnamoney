class UsersController < ApplicationController
  
  before_filter :cant_create_user_without_store, :only => [:new, :create]
  before_filter :provide_payment_information, :only => [:new, :create]

  def index
    respond_to do |format|
      format.js {
        @users = User.store_status_is('activated').names_or_last_names_like_all(params[:q].to_s.split) + User.store_status_is('activated').store_id_is(params[:q])
      }
      format.html { 
        @users = User.all.paginate(:page => params[:page], :per_page => 20)
      }
    end
  end

  def new
    @user = User.new  
  end

  def create
    cookies.delete :auth_token
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      Store.find(session[:store_id]).user_is!(@user)
      session[:user_id] = @user.id
      self.current_user = @user
      redirect_to new_user_payment_information_path(@user)
      flash[:notice] = "Tu informaci&oacute;n se guard&oacute; correctamente"
    else
      render :action => 'new'
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Registro completo!"
    end
    redirect_back_or_default('/')
  end
  
  private
  
  def cant_create_user_without_store
    if session[:store_id].nil?
      flash[:error] = "Para registrar tu informaci&oacute;n primero crea tu tienda"
      redirect_to new_store_path
      return false
    end
  end
  
  def provide_payment_information
    if session[:user_id]
      @user = User.find_by_id(session[:user_id])
      flash[:notice] = "Por favor completa tu registro"
      redirect_to new_user_payment_information_path(@user)
      return false
    end
  end
end

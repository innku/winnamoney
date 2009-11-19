class UsersController < ApplicationController
  
  before_filter       :cant_create_user_without_store, :only => [:new, :create]
  before_filter       :login_required, :only => [:edit, :update]
  skip_before_filter  :find_store, :only => [:activate]

  def index
    respond_to do |format|
      format.js {
        @users = User.store_status_is('activated').names_or_last_names_like_all(params[:q].to_s.split) + User.store_status_is('activated').store_id_is(params[:q])
      }
      format.html { 
        if params[:keyword]
          keyword = params[:keyword].split.empty? ? nil : params[:keyword].split
        end
        status = params[:status] unless params[:status] == "0"
        @users = User.names_or_last_names_or_email_or_id_or_ssn_or_phone_like_all(keyword).store_status_like(status).paginate(:page => params[:page], :per_page => 20)
      }
    end
  end

  def new
    @user = User.new 
    render :layout => 'register' 
  end

  def create
    cookies.delete :auth_token
    @user = User.find_and_edit(session[:registered_user_id], params[:user]) || User.new(params[:user])
    @user.save
    if @user.errors.empty?
      Store.find(session[:registered_store_id]).user_is!(@user)
      session[:registered_user_id] = @user.id
      redirect_to new_order_path()
      flash[:notice] = "Register successful!"
    else
      render :action => 'new', :layout => 'register'
    end
  end
  
  def edit
    @user = @current_user.is_admin? ? User.find(params[:id]) : @current_user
    case params[:edit_action]
      when "unsubscribe"
        render 'unsubscribe'
      when "change_password"
        render 'change_password'
      else
        render
    end
  end
  
  def update
    @user = @current_user.is_admin? ? User.find(params[:id]) : @current_user
    case params[:update_action]
      when "change_password"
        if User.authenticate(@user.store, @user.email, params[:old_password])
          if not params[:user][:password].blank? and @user.update_attributes(params[:user])
            flash[:info] = "The password changed successfully!"
            redirect_to @user
          else
            flash[:error] = "Password change failed"
            render 'change_password'
          end
        else
          flash.now[:error] = "The current password you provided incorrect"
          render 'change_password'
        end
      else
        if @user.update_attributes(params[:user])
          flash[:notice] = "Information updated successfully"
          redirect_to @user
        else
          render :edit
        end
    end
  end
  
  def show
    @user = @current_user.is_admin? ? User.find(params[:id]) : @current_user
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      @current_store = current_user.store
      flash[:notice] = "Register completed! You need to complete your payment before your store is ready to sell"
    end
    redirect_back_or_default('/')
  end
  
  def destroy
    @user = User.find(params[:id])
    unless @user.store.incomplete?
      @user.store.unsubscribe!
      redirect_to users_path
    else
      @user.destroy
      redirect_to users_path
    end
  end
  
  private
  
  def cant_create_user_without_store
    if session[:registered_store_id].nil?
      flash[:error] = "Please create a store first"
      redirect_to new_store_path
      return false
    end
  end
  
end

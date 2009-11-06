class UsersController < ApplicationController
  
  before_filter :cant_create_user_without_store, :only => [:new, :create]

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
        @users = User.names_or_last_names_or_email_or_id_like_all(keyword).store_status_like(status).paginate(:page => params[:page], :per_page => 20)
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
      session[:registered_user_id] = @user.id
      redirect_to new_order_path()
      flash[:notice] = "Register successful!"
    else
      logger.warn @user.errors.full_messages
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
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
    @user = User.find(params[:id])
    case params[:update_action]
      when "unsubscribe"
        @current_user.unsubscribe!
        flash[:notice] = "Your request was received successfully!"
        redirect_to edit_user_path(@current_user, :edit_action => 'unsubscribe')
      when "change_password"
        if User.authenticate(@user.email, params[:old_password])
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
    @user = User.find(params[:id])
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Register completed!"
    end
    redirect_back_or_default('/')
  end
  
  private
  
  def cant_create_user_without_store
    if session[:store_id].nil?
      flash[:error] = "Please create a store first"
      redirect_to new_store_path
      return false
    end
  end
  
end

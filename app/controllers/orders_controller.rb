class OrdersController < ApplicationController
  before_filter :find_cart, :only => [:new, :create, :express]
  before_filter :can_create_order, :only => [:new, :create]
  
  def new
    if in_register_process?
      @user = User.find(session[:registered_user_id])
      build_order_types(:current_order => nil, :payment_type => 'suscription')
      render :action => 'new', :layout => 'register'
    else
      build_order_types(:current_order => nil, :payment_type => 'product_purchase')
      render 'confirm_order'
    end
  end
  
  def create
    if !in_register_process?
      @order = @cart.orders.build(params[:order])
      @order.user = @current_user
    else
      @user = User.find(session[:registered_user_id])
      @order = @user.orders.build(params[:order])
    end
    @order.ip_address = request.remote_ip
    if @order.save
      clear_register_session
      clear_shopping_session
      case @order.payment_method
        when "credit_card"
          if @order.purchase!
            @order.complete!
            render 'success_credit_card', :layout => 'confirmation'
          else
            @order.decline!
            render 'failure_credit_card', :layout => 'confirmation'
          end
        when "deposit"
          if @order.suscription?
            @order.user.store.stand_by!
            render 'success_deposit', :layout => 'confirmation'
          else
            @order.stand_by!
            render 'success_deposit', :layout => 'confirmation'
          end
        when "contact_later"
          if @order.suscription?
            @order.user.store.contact_me!
            render 'success_contact', :layout => 'confirmation'
          else
            @order.contact_me!
            render 'success_contact', :layout => 'confirmation'
          end
      end
    else
      if in_register_process?
        build_order_types(:current_order => @order, :payment_type => 'suscription')
        render :action => 'new', :layout => 'register'
      else
        build_order_types(:current_order => @order, :payment_type => 'product_purchase')
        render 'confirm_order'
      end
    end
  end
  
  def express
    if not in_register_process?
      @order = @cart.orders.build
    else
      @user = User.find(session[:registered_user_id])
      @order = @user.orders.build
    end
    response = EXPRESS_GATEWAY.setup_purchase(@order.price_in_cents, 
    :ip => request.remote_ip,
    :return_url => new_order_url(),
    :cancel_return_url => new_order_url())
    
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
  
  private
  
  def build_cart_order_types(options)
      @credit_card_order = (not options[:current_order].nil? and options[:current_order].credit_card?) ? options[:current_order] : Order.new()
      @express_checkout_order = Order.new(:express_token => params[:token])
      if options[:is_suscription]
        @credit_card_order.order_type = 'suscription'
        @express_checkout_order.order_type = 'suscription'
      end
  end
  
  def build_order_types(options)
      @deposit_order = build_order(options[:current_order], 'deposit', options[:payment_type]) 
      @contact_later_order = build_order(options[:current_order], 'contact_later', options[:payment_type])
      @credit_card_order = build_order(options[:current_order], 'credit_card',options[:payment_type])
      @express_checkout_order = build_order(options[:current_order], 'express_checkout',options[:payment_type])
  end
  
  def build_order(current_order, payment_method, order_type)
    if (!current_order.nil? and current_order.payment_method == payment_method)
      return current_order
    else
      order =  Order.new(:payment_method => payment_method, :order_type => order_type)
      order.express_token = params[:token] if payment_method == 'express_checkout'
      order.order_type = order_type
      order
    end
  end
  
  def can_create_order
    logger.warn in_shopping_process?.inspect
    unless (in_register_process? or in_shopping_process?)
      redirect_to @current_store
      return false
    end
  end
  
end
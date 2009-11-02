class PaymentInformationController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @payment_information = PaymentInformation.new(:contact_me => true)
  end
  
  def create
    @user = User.find(params[:user_id])
    @payment_information = @user.build_payment_information(params[:payment_information])
    if @payment_information.save
      session[:user_id], session[:store_id] = nil
      if @payment_information.contact_me?
        @user.store.contact_me!
        render 'success_contact'
      else
        @user.store.stand_by!
        render 'success_deposit'
      end
    else
      render :new
    end
  end
end
class SiteController < ApplicationController
  
  def home
    @product = Product.featured.first
  end
  
  def news
    @product = Product.featured.first
  end
  
  def company
  
  end
  
  def oportunity
    
  end
  
  def contact
    UserMailer.deliver_contact(params)
    unless params[:email].blank? and params[:message].blank?
      flash[:notice] = "Your message was sent successfully"
      redirect_to company_path + "#message"
    else
      flash[:error] = "We need at least your email address and message"
      redirect_to company_path + "#message"
    end
  end
  
end
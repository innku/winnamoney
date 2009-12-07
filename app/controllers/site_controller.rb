class SiteController < ApplicationController
  
  def home
    @product = Product.featured.first
  end
  
  def news
  
  end
  
  def company
  
  end
  
  def oportunity
    
  end
  
end
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
  
end
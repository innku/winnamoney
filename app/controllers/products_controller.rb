require "will_paginate"

class ProductsController < ApplicationController
  
  before_filter :admin_required, :only => [:index, :new, :create, :edit, :update, :destroy]
  before_filter :find_cart, :only => [:show]
  before_filter :clear_register_session, :only => [:show]
  
  
  def index
    if params[:keyword]
      keyword = params[:keyword].split.empty? ? nil : params[:keyword].split
    end
    category = params[:category] if params[:category] and params[:category].to_i > 0
    on_home = params[:on_home].nil? ? nil : 1
    @products = Product.name_or_product_key_like_all(keyword).tag_subcategory_category_id_like(category).on_home_like(on_home).paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @product = Product.find(params[:id])
    if @current_user and @current_user.is_admin?
      render 'show'
    else
      render :action => 'details', :layout => 'stores'
    end
  end
  
  def new
    unless params[:new_type] == 'mass'
      @product = Product.new
      render
    else
      render 'mass_new'
    end
  end
  
  def create
    @product = Product.new(params[:product])
    case params[:create_type]
      when 'mass'
        if Product.upload_file(params[:products_csv])
          if Product.read_from_file(params[:category_mass])
            flash[:notice] = "Tu archivo se ley&oacute; con &eacute;xito"
          else
            flash[:error] = "Hubo un error al leer el archivo"
          end
            redirect_to products_path
        else
          flash[:error] = "Hubo un error al procesar tu archivo"
          redirect_to new_product_path(:new_type => 'mass')
        end
      when 'discount'
        if Product.discount!(params[:discount])
          flash[:notice] = "All the products have now a discount of #{params[:discount]}%"
        else
          flash[:error] = "There was an error with the discount you provided"
        end
        redirect_to products_path
      else
        if @product.save
          flash[:notice] = "El producto se cre&oacute; con &eacute;xito."
          redirect_to @product
        else
          render :action => 'new'
        end
      end
    end
  
  def edit
    @product = Product.find(params[:id])
  end
  
  def update
    @product = Product.find(params[:id])
    respond_to do |format|
      if params[:update_type] == "home_update"
        params[:value] == "true" ? @product.add_to_home! : @product.remove_from_home!
        format.js { render :nothing => true }
      else
        if @product.update_attributes(params[:product])
          flash[:notice] = "El producto se edit&oacute; con &eacute;xito"
          format.html { redirect_to @product } 
        else
          format.html { render :action => 'edit' } 
        end
      end
    end
  end
  
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    flash[:notice] = "El producto se borr&oacute; con &eacute;xito"
    redirect_to products_url
  end
end

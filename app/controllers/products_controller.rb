require "will_paginate"

class ProductsController < ApplicationController
  def index
    @products = Product.all.paginate(:page => params[:page], :per_page => 20)
  end
  
  def show
    @product = Product.find(params[:id])
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
    unless params[:create_type] == 'mass'
      if @product.save
        flash[:notice] = "El producto se cre&oacute; con &eacute;xito."
        redirect_to @product
      else
        render :action => 'new'
      end
    else
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
    end
  end
  
  def edit
    @product = Product.find(params[:id])
  end
  
  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      flash[:notice] = "El producto se edit&oacute; con &eacute;xito"
      redirect_to @product
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    flash[:notice] = "El producto se borr&oacute; con &eacute;xito"
    redirect_to products_url
  end
end

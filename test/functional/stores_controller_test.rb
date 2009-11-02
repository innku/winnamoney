require 'test_helper'

class StoresControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Store.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Store.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Store.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to store_url(assigns(:store))
  end
  
  def test_edit
    get :edit, :id => Store.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Store.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Store.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Store.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Store.first
    assert_redirected_to store_url(assigns(:store))
  end
  
  def test_destroy
    store = Store.first
    delete :destroy, :id => store
    assert_redirected_to stores_url
    assert !Store.exists?(store.id)
  end
end

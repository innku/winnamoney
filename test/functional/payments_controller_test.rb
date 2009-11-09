require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  def test_create_invalid
    Payment.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Payment.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to root_url
  end
end

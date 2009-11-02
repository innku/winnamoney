require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Store.new.valid?
  end
end

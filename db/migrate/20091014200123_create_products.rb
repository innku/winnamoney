class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string  :name
      t.string  :product_key
      t.text    :description
      t.integer :existence
      t.float   :local_transport
      t.float   :international_transport
      t.float   :cost
      t.integer :discount
      t.float   :selling_price
      t.string   :small_image_url
      t.string   :medium_image_url
      t.string   :big_image_url
      t.float   :handling
      t.timestamps
    end
  end
  
  def self.down
    drop_table :products
  end
end

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :names,                     :string
      t.column :last_names,                :string
      t.column :city_id,                   :integer
      t.column :address_1,                 :string
      t.column :address_2,                 :string
      t.column :phone,                     :string
      t.column :phone_extension,           :string
      t.column :fax,                       :string
      t.column :fax_extension,             :string
      t.column :email,                     :string
      
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code, :string, :limit => 40
      t.column :activated_at, :datetime
      
    end
  end

  def self.down
    drop_table "users"
  end
end

class CreateStates < ActiveRecord::Migration
  
  def self.up
    create_table :states do |t|
      t.string :name
      t.string :abbr
      t.string :short
      t.string :short2
    end
    
    change_table :products do |t|
      t.integer :state_id
    end
    
  end

  def self.down
    drop_table :states
  end
  
end

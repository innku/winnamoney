class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table  :countries  do  |t|
      t.string  :name
    end
    
    change_table  :states  do  |t|
      t.integer  :country_id
    end
    
  end

  def self.down
    drop_table  :countries
    
    change_table  :states  do  |t|
      t.remove  :country_id
    end
    
  end
end

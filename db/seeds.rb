require 'fastercsv'

Country.create!(:name => "México")
Country.create!(:name => "United States")

states = FasterCSV.read(RAILS_ROOT + "/db/csv/states.csv")

states[1..-1].each do |state|
  State.create!(:id => state[0], :name => state[1], :country_id => state[2], :short => state[3], :abbr => state[4], :short2 => state[5])
end

cities = FasterCSV.read(RAILS_ROOT + "/db/csv/cities.csv")

cities[1..-1].each do |city|
  City.create!(:id => city[0], :name => city[1], :state_id => city[2], :city_name => city[3], :priority => city[4])
end

User.create(:names => 'Rafael', :last_names => 'Rosas', :email => 'rrosa@gmx.us', :city_name => 'Monterrey', :address_1 => 'San Pedro', :address_2 => 'Nuevo Leon', :phone => '8182441327', :password => 'winnamoney', :password_confirmation => 'winnamoney', :parent_id => nil)

User.first.create_store(:name => 'www', :language => 'spanish', :sponsor_id => nil, :parent_id => nil, :positioning => 'automatic', :status => 'activated')
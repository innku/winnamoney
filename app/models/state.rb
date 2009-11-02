class State < ActiveRecord::Base
  has_many  :cities
  belongs_to  :country
  
  named_scope :like, lambda {|name| {:conditions => ["states.name LIKE '%%#{name}%%' or states.abbr = '%%#{name}%%' OR states.short = '%%#{name}%%' or states.short2 = '%%#{name}%%'"]} }
  
  def self.find_by_full_name(name)
    unless name.blank?
      @states = State.like(name)
      @states
    else
      []
    end
  end
  
end
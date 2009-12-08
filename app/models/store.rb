class Store < ActiveRecord::Base
  
  STATUS = [["Activated", "activated"], ["Stand By", "stand_by"], ["Contact Me", "contact_me"], ["Incomplete", "incomplete"]]
  OWNER_DISCOUNT = 0.15
  LANGUAGES=[['English', 'english'],['Español', 'spanish']]
  POSITIONING= [['Automatic','automatic'],['Right','right'],['Left','left']]
  
  belongs_to                :user
  belongs_to                :left, :class_name => 'Store', :foreign_key => 'left_id'
  belongs_to                :right, :class_name => 'Store', :foreign_key => 'right_id'
  belongs_to                :parent, :class_name => 'Store', :foreign_key => 'parent_id'
  belongs_to                :sponsor, :class_name => 'Store', :foreign_key => 'sponsor_id'
  has_many                  :carts
  
  validates_presence_of     :name, :message => 'Your store must have a name'
  validates_uniqueness_of   :name, :message => 'There is another store with that name'
  validates_format_of       :name,       
                            :message => 'Your store subdomain can only contain alphanumeric characters',                  
                            :with => /^[a-zA-Z0-9]+$/  
                            
  validates_presence_of     :language, :message => 'What language do you want your store to default to?'
  validates_presence_of     :positioning, :message => 'You should select an automatic way for your referrals to position to'
  
  named_scope               :with_status, lambda {|status| {:conditions => ["status = '#{status}'"]} }
  named_scope               :complete, :conditions => ["user_id is not null"]
  after_create              :set_parent_position
  
  attr_accessible :name, :language, :sponsor_id, :positioning, :sponsor_name, :parent_id, :level, :dummy,:side
  
  attr_accessor   :level, :side, :dummy
  
  def self.find_and_edit(id, params)
    store = find_by_id(id)
    unless store.nil?
      store.attributes = params
    end
    store
  end
  
  def self.with_subdomain(sub)
    subdomain, domain = sub.split(".")
    if ["www", "winnamoney"].include?(subdomain)
      Store.first
    else
      Store.find_by_name(subdomain)
    end
  end
  
  def locale
    self.language == "english" ? "en" : "es"
  end
  
  def sponsor_name=(s_name)
    write_attribute(:sponsor_name, s_name)
    name, id = s_name.split(',')
    self.sponsor = Store.find_by_id(id) || Store.find_by_id(name)
  end
  
  def sponsor_name
    if self.new_record?
      read_attribute(:sponsor_name)
    else
      if self.sponsor
        read_attribute(:sponsor_name) || [self.sponsor.user.full_name, self.sponsor.id].join(", ")
      end
    end
  end
  
  def active?
    self.status == "activated" or self.status == "unsubscribe_request"
  end
  
  def incomplete?
    self.status == "incomplete"
  end
  
  def position_taken?
    self.status == "activated" or self.status == "unsubscribed"
  end
  
  def inactive?
    self.status == "contact_me" or self.status == "stand_by" or self.status == "incomplete"
  end
  
  def payment_due?
    self.status == "contact_me" or self.status == "stand_by"
  end
  
  def dummy?
    self.dummy
  end
  
  def owner?(u)
    self.user == u
  end
  
  def activate!
    self.status = 'activated'
    if self.parent.nil?
      self.assign_position!
    else
      self.save
    end
  end
  
  def contact_me!
    self.status = 'contact_me'
    self.save
  end
  
  def stand_by!
    self.status = 'stand_by'
    self.save
  end
  
  def unsubscribe_request!
    self.status = 'unsubscribe_request'
    self.save
  end
  
  def unsubscribe!
    self.status = 'unsubscribed'
    self.save
  end
  
  def unsubscribe_request?
    self.status == 'unsubscribe_request'
  end
  
  def user_is!(user)
    self.user = user
    self.save
  end
  
  def left!(node)
    self.left = node
    node.parent = self
    self.save and node.save
  end
  
  def right!(node)
    self.right = node
    node.parent = self
    self.save and node.save
  end
  
  def not_assigned?
    self.parent.nil?
  end
  
  def self.root
    Store.first
  end
  
  def toggle_position!
    self.auto_turn = (self.auto_turn == 'right') ? 'left' : 'right'
    self.save
  end
  
  def referrals
    Store.complete.sponsor_id_is(self.id)
  end
  
  def downline(params)
    q = Queue.new
    q << self.set_level(0)
    result = []
    while !q.empty? do
      node = q.pop
      result << node
      if node.level < params[:levels]
        if !node.new_record?
          if node.left and node.left.position_taken?
            q << node.left.set_level(node.level + 1)
          else
            q << Store.new(:parent_id => node.id, :side => 'left').set_level(node.level + 1)
          end
          if node.right and node.right.position_taken?
            q << node.right.set_level(node.level + 1) 
          else
            q << Store.new(:parent_id => node.id, :side => 'right').set_level(node.level + 1)
          end
        else
          q << Store.new(:dummy => true, :level => (node.level + 1))
          q << Store.new(:dummy => true, :level => (node.level + 1))
        end
      end
    end
    result
  end
  
  def set_level(l)
    self.level = l
    self
  end
  
  protected
  
  def set_parent_position
    if self.side and self.parent
      parent = self.parent
      if self.side == "left"
        if (parent.left.nil? or !parent.left.position_taken?)
          parent.left = self
        else
          self.parent = nil
          self.save
        end
      elsif self.side == "right"
        if (parent.right.nil? or !parent.right.position_taken?)
          parent.right = self
        else
          self.parent = nil
          self.save
        end
      end
      parent.save
    end
  end
  
  def validate
    errors.add(:sponsor_id, "We could'nt find any sponsors with the information you provided") if sponsor.nil? and not read_attribute(:sponsor_name).blank?
  end
  
  def assign_position!
    if self.not_assigned?
      root = sponsor || Store.root
      root.position_node!(self)
    else
      false
    end
  end
  
  def position_node!(node)
    if positioning == 'left' or (positioning == 'automatic' and auto_turn == 'left')
      self.toggle_position! if self.positioning == 'automatic'
      return self.bottom_left.left!(node)
    else
      self.toggle_position! if self.positioning == 'automatic'
      return self.bottom_right.right!(node)
    end
  end
  
  def bottom_left
    (self.left.nil? or !self.left.position_taken?) ? self : self.left.bottom_left
  end
  
  def bottom_right
    (self.right.nil? or !self.right.position_taken?) ? self : self.right.bottom_right
  end
  
end

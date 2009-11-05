class Store < ActiveRecord::Base
  
  STATUS = [["Activated", "activated"], ["Stand By", "stand_by"], ["Contact Me", "contact_me"]]
  
  belongs_to                :user
  belongs_to                :left, :class_name => 'Store', :foreign_key => 'left_id'
  belongs_to                :right, :class_name => 'Store', :foreign_key => 'right_id'
  belongs_to                :parent, :class_name => 'Store', :foreign_key => 'parent_id'
  belongs_to                :sponsor, :class_name => 'Store', :foreign_key => 'sponsor_id'
  has_many                  :carts
  
  validates_presence_of     :name, :message => 'Tu tienda debe tener un nombre'
  validates_uniqueness_of   :name, :message => 'Ya existe una tienda con ese nombre'
  validates_presence_of     :language, :message => '&iquest;En que idioma estar&aacute; tu tienda?'
  validates_presence_of     :positioning, :message => '&Debes elegir de que manera se posicionar&aacute;n tus inscritos'
  
  named_scope               :with_status, lambda {|status| {:conditions => ["status = '#{status}'"]} }
  
  LANGUAGES=[['Español', 'spanish'],['English', 'english']]
  POSITIONING= [['Automatic','automatic'],['Right','right'],['Left','left']]
  attr_accessible :name, :language, :sponsor_id, :positioning, :sponsor_name
  
  def self.with_subdomain(sub)
    subdomain, domain = sub.split(".")
    if ["www", "winnamoney"].include?(subdomain)
      store = Store.first
    else
      Store.find_by_name(subdomain)
    end
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
  
  def inactive?
    self.status == "contact_me" or self.status == "stand_by" or self.status == "incomplete"
  end
  
  def activate!
    self.status = 'activated'
    self.assign_position!
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
  
  protected
  
  def validate
    errors.add(:sponsor_id, "No encontramos a tu patrocinador con la informaci&oacute;n que proporcionaste") if sponsor.nil? and not read_attribute(:sponsor_name).blank?
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
    self.left.nil? ? self : self.left.bottom_left
  end
  
  def bottom_right
    self.right.nil? ? self : self.right.bottom_right
  end
  
end

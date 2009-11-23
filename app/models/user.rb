require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  
  belongs_to                :city
  has_one                   :store
  has_many                  :orders

  validates_presence_of     :email
  validates_presence_of     :names
  validates_presence_of     :last_names
  validates_presence_of     :city_id
  validates_presence_of     :address1
  validates_presence_of     :phone
  validates_presence_of     :account_type
  validates_presence_of     :account_number
  validates_presence_of     :routing
  validates_presence_of     :ssn

  validates_numericality_of :phone
  validates_numericality_of :fax, :allow_blank => true
  validates_numericality_of :cell, :allow_blank => true
  validates_presence_of     :password,                   :if => :password_required?,
                            :message => "You must provide a password"
  validates_presence_of     :password_confirmation,      :if => :password_required?,
                            :message => "You must provide a password confirmation"
  validates_length_of       :password, :within => 4..40, :if => :password_required?,
                            :message => "The password you provided is too small"
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :email,    :within => 3..100, 
                            :message => "Your email doesn't' have a correct format"
  validates_uniqueness_of   :email, :case_sensitive => false, 
                            :message => 'We already have that e-mail on our database'
  before_save               :encrypt_password
  before_create             :make_activation_code
  
  attr_accessible :names, :last_names, :city_name, :address1, :address2,:zip, :phone, :phone_extension, :fax, :fax_extension, :email, :password, :password_confirmation,:cell,:account_type, :account_number,:routing,:ssn
    
  after_validation :validate_cities
  
  def self.admin
    if ENV["RAILS_ENV"] == 'production'
      User.find_by_email("rrosa@gmx.us")
    else
      User.new(:email => 'adrian@innku.com')
    end
  end
  
  def self.find_and_edit(id, params)
    user = find_by_id(id)
    unless user.nil?
      user.attributes = params
    end
    user
  end
  
  def full_name
    self.names + " " + self.last_names
  end

  def city_name
    if city
      return "#{self.city.name}, #{self.city.state.name}"
    end
  end
  
  def city_name=(city_name)
    write_attribute(:city_name, city_name)
    @cities = City.find_by_full_name(city_name)
    if @cities.size == 1
      self.city = @cities.first
    else
      self.city = nil
    end
  end

  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(store, email, password)
    s = Store.find :first, :conditions => ['id = ?', store]
    unless s.nil?
      u = s.user if s.user.email == email and !s.user.activated_at.nil?
    end
    # u = find :first, :conditions => ['store_id email = ? and activated_at IS NOT NULL', email] # need to get the salt
    logger.warn u.inspect
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  def create_reset_code
    @reset = true
    self.reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    self.save
  end 
  
  def recently_reset?
    @reset
  end 

  def delete_reset_code
    self.attributes = {:reset_code => nil}
    save(false)
  end
  
  def is_admin?
    is_admin
  end
  
  def already_requested?
    self.store.unsubscribe_request?
  end

  protected
  
    def validate_cities
       if !self.city and @cities
          if @cities.size > 1
            errors.add(:city_id, "We found many cities with your request, please be more specific using the <em>City, State</em> format")
          else @cities.size == 0
            errors.add(:city_id, "We haven't found any city with your request")
          end
        end
    end
  
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
end

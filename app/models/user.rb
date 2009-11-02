require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  
  belongs_to                :city
  has_one                   :store
  has_one                   :payment_information

  validates_presence_of     :email, :message => 'Debes tener un correo electr&oacute;nico'
  validates_presence_of     :names, :message => 'Debes proporcionar tu(s) nombre(s)'
  validates_presence_of     :last_names, :message => 'Debes proporcionar tu(s) apellido(s)'
  validates_presence_of     :city_id, :message => 'Debes proporcionar tu ciudad'
  validates_presence_of     :address_1, :message => 'Debes proporcionar tu direcci&oacute;n'
  validates_presence_of     :phone, :message => 'Debes proporcionar tu tel&eacute;fono'
  
  validates_presence_of     :password,                   :if => :password_required?,
                            :message => 'Debes proporcionar un passwords'
  validates_presence_of     :password_confirmation,      :if => :password_required?,
                            :message => 'Debes proporionar la confirmaci&oacute;n de tu password'
  validates_length_of       :password, :within => 4..40, :if => :password_required?,
                            :message => 'Tu password debe tener de 4 a 40 caracteres de largo'
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :email,    :within => 3..100, 
                            :message => 'Tu correo puede tener entre 3 y 100 caracteres de largo'
  validates_uniqueness_of   :email, :case_sensitive => false, 
                            :message => 'Tu correo electr&oacute;nico ya existe en nuestra base de datos'
  before_save               :encrypt_password
  before_create             :make_activation_code
  
  attr_accessible :names, :last_names, :city_name, :address_1, :address_2, :phone, :phone_extension, :fax, :fax_extension, :email, :password, :password_confirmation
  
  after_validation :validate_cities
  
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
  def self.authenticate(email, password)
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] # need to get the salt
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

  protected
  
    def validate_cities
       if !self.city and @cities
          if @cities.size > 1
            errors.add(:city_id, "Encontramos muchas ciudades con el nombre que nos diste, por favor especif&iacute;cala en el formato <em>Ciudad, Estado</em>")
          else @cities.size == 0
            errors.add(:city_id, "No encontramos ninguna ciudad con el nombre que nos diste")
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

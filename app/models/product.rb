class Product < ActiveRecord::Base
  require 'fastercsv'
  FILE_PATH = File.join(RAILS_ROOT, "public/files", "products.csv")
  
  belongs_to  :state
  belongs_to  :tag
  has_many    :cart_items
  
  attr_accessible :name, :product_key, :description, :existence, :local_transport, :international_transport, :cost, :discount, :selling_price, :small_image_url, :medium_image_url, :big_image_url, :handling, :state_name, :tag_id
  
  validates_presence_of     :name,
                            :message => 'El producto debe tener un nombre'
                            
  validates_presence_of     :tag_id,
                            :message => 'El producto debe tener una categor&iacute;a'
  
  validates_presence_of     :product_key,
                            :message => 'El producto debe tener una clave'
  
  validates_numericality_of   :selling_price,
                              :message => 'El precio de venta debe ser num&eacute;rico'
  validates_numericality_of   :existence, :allow_nil => true,
                              :message => 'La existencia debe ser num&eacute;rica'
                              
  validates_numericality_of   :local_transport, :allow_nil  => true,
                              :message => 'El precio del transporte local debe ser num&eacute;rico'
  validates_numericality_of   :international_transport, :allow_nil => true,
                              :message => 'El precio del transporte internacional debe ser num&eacute;rico'
  validates_numericality_of   :cost, :allow_nil => true,
                              :message => 'El costo debe ser num&eacute;rico'

  named_scope                 :like, lambda {|q| {:include => :tag, :conditions => ["products.name LIKE '%%#{q}%%' or tags.name LIKE '%%#{q}%%'"]} }
  named_scope                 :tag_group, {:group => 'tag_id'}
  named_scope                 :category_group, {:include => {:tag => :subcategory}, :group => 'subcategory_id'}
    
  attr_accessor :category_id, :subcategory_id
  
  def self.featured
    Category.all.collect {|c| c.subcategories.first.tags.first.products.first if (not c.subcategories.first.nil? and not c.subcategories.first.tags.first.nil?) } - [nil]
  end
  
  def category_id
    if tag
      return tag.subcategory.category.id
    end
  end
  
  def subcategory_id
    if tag
      return tag.subcategory.id
    end
  end
  
  def self.upload_file(csv_file)
    File.new(FILE_PATH) unless ( not File.file?(FILE_PATH))
    File.open(FILE_PATH, "wb") { |f| f.write(csv_file.read) }
  end
  
  def self.read_from_file(category)
    if (File.file?(FILE_PATH) and category = Category.find(category))
      raw_products = FasterCSV.read(FILE_PATH)
      raw_products[1..-1].each do |raw_product|
        product = Product.find_by_product_key(raw_product[0]) || Product.new
        product.product_key = raw_product[0]
        product.name = raw_product[1]
        product.description = raw_product[4]
        product.existence = raw_product[14]
        product.local_transport = raw_product[10]
        product.international_transport = raw_product[11]
        product.selling_price = raw_product[26]
        product.small_image_url = raw_product[15]
        product.medium_image_url = raw_product[16]
        product.big_image_url = raw_product[17]
        product.handling = raw_product[12]
        product.cost = raw_product[6]
        product.tax = raw_product[23]
        product.discount = raw_product[33]
        product.state_name = raw_product[22]
        subcategory = category.subcategories.find_by_name(raw_product[2]) || category.subcategories.create(:name => raw_product[2] )
        product.tag = subcategory.tags.find_by_name(raw_product[3]) || subcategory.tags.create(:name => raw_product[3])
        product.save
      end
      return true
    end
    false
  end
  
  def state_name
    if state
      state.name
    end
  end
  
  def price_for_owner
    self.selling_price * (1 - Store::OWNER_DISCOUNT)
  end
  
  def state_name=(state_name)
    write_attribute(:state_name, state_name)
    @states = State.find_by_full_name(state_name)
    if @states.size == 1
      self.state = @states.first
    else
      self.state = nil
    end
  end
  
end

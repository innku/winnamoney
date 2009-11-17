# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def display?(condition)
    condition ? "" : "display:none"
  end
  
  def display_string?(string, condition)
    condition ? string : ""
  end
  
  def format_address(address1, address2, city_name, zip_code)
    address = ""
    address += "#{address1}"
    address += " #{address2}" if address2
    address += " #{city_name}"
    address += ". #{zip_code}"
    address
  end
  
  
  def breadcrumb_links
    links = ""
    if controller_name == "stores"
      links += "<li>#{link_to 'Store', @current_store, :class=> 'active'}</li>"
    elsif controller_name == 'subcategories' || controller_name == 'tags'
      subcategory = @subcategory || @tag.subcategory
      links += "<li>#{link_to 'Store', @current_store}</li>"
      links += "<li>#{link_to subcategory.name, subcategory}</li>"
      subcategory.tags.each do |tag|
        links += "<li>#{link_to tag.name, tag, :class=> 'active'}</li>"
      end
    elsif controller_name == "products"
      links += "<li>#{link_to 'Store', @current_store}</li>"
      links += "<li>#{link_to @product.tag.subcategory.name, @product.tag.subcategory}</li>"
      links += "<li>#{link_to @product.tag.name, @product.tag}</li>"
      links += "<li>#{link_to @product.name, @product,:class=> 'active'}</li>"
    end
    links
  end
  
end

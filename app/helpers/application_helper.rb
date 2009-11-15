# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def display?(condition)
    condition ? "" : "display:none"
  end
  
  def format_address(address1, address2, city_name, zip_code)
    address = ""
    address += "#{address1}"
    address += " #{address2}" if address2
    address += " #{city_name}"
    address += ". #{zip_code}"
    address
  end
  
end

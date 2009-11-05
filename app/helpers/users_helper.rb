module UsersHelper
  def all_statuses_option
    "<option value='0'>Any Status</option>"
  end
  
  def format_address(address1, address2, city_name, zip_code)
    address = ""
    address += "#{address1}"
    address += " #{address2}" if address2
    address += " #{city_name}"
    address += ". #{zip_code}"
    address
  end
  
  def format_phone(phone_number, extension)
    phone = ""
    phone += "#{phone_number}"
    phone += " ext. #{extension}" unless extension.nil?
    phone
  end
  
end
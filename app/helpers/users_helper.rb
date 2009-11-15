module UsersHelper
  def all_statuses_option
    "<option value='0'>Any Status</option>"
  end
  
  def format_phone(phone_number, extension)
    phone = ""
    phone += "#{phone_number}"
    phone += " ext. #{extension}" unless extension.blank?
    phone
  end
  
end
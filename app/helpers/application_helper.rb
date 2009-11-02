# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  #displays the attributes first error message
  def error_messages_for (obj)
    unless obj.errors.empty?
      error_messages = []
      obj.attributes.keys.each do |attribute|
        if obj.errors[attribute].is_a?(Array)
          error_messages << obj.errors[attribute].first unless obj.errors[attribute].nil?
        elsif obj.errors[attribute]
          error_messages << obj.errors[attribute] unless obj.errors[attribute].nil?
        end
      end
      render :partial => "application/error_messages", :locals => {:error_messages => error_messages}
    end
  end
  
end

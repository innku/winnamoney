module StoresHelper

  def store_title
    title = "Winnamoney | Store"
    subcategory = @subcategory || (@tag.subcategory if @tag) || nil
    title += " | #{subcategory.name}" if subcategory
    title += " | #{@tag.name}" if @tag
    title
  end
  
  def store_heading
    if @subcategory
      return @subcategory.name
    elsif @tag
      return @tag.subcategory.name + " &raquo; " + @tag.name
    else
      return "#{@store.name.titleize} Store"
    end
  end
  
  def results_description
    if controller_name != 'stores' or not params[:q].nil?
      return "<p> Listing <b>#{@products.size} of #{@products.total_entries}</b> products</p>"
    end
  end
  
  def list_tags
    if controller_name == "subcategories"
      links = "Categories: "
      @subcategory.tags.each do |tag|
        links+= link_to(tag.name, tag_path(tag))
        unless tag == @subcategory.tags.last
          links+= ", " 
        else
          links+= "<br /><br />" 
        end
      end
    end
    return links
  end
  
end

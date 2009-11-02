module ProductsHelper
  def categories_for_select
   options = "<option value='-1' selected='selected'></option>"
   options +=  options_from_collection_for_select(Category.all, 'id', 'name')
   options += "<option value='0'>Nueva categor&iacute;a...</option>"
   options
  end
end

$(document).ready(function(){
	
	$(document).ajaxSend(function(event, request, settings) {
	  if (typeof(AUTH_TOKEN) == "undefined") return;
	  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
	  settings.data = settings.data || "";
	  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
	});
	
	//PRODUCTS
	
	$("select#product_category_id").change(function(element){
		if($("#product_category_id").val() > 0){
			$.getJSON("/subcategories", {category_id: $("#product_category_id").val()}, 
			function(data){
				$("select#product_subcategory_id").empty();
				$("select#product_tag_id").empty();
				$("select#product_subcategory_id").append("<option value='0'></option>");
				for(i=0;i<data.length;i++){
					option = "<option value='"+data[i].id+"'>"+data[i].name+"</option>";
					$("select#product_subcategory_id").append(option);
				}
			});
		}
	});
	
	$("select#product_subcategory_id").change(function(element){
		if($("#product_subcategory_id").val() > 0){
			$.getJSON("/tags", {subcategory_id: $("#product_subcategory_id").val()}, 
			function(data){
				$("select#product_tag_id").empty();
				for(i=0;i<data.length;i++){
					option = "<option value='"+data[i].id+"'>"+data[i].name+"</option";
					$("select#product_tag_id").append(option);
				}
			});
		}else{
			$("select#product_tag_id").empty();
		}
	});
	
	//Autocomplete Cities -- 

	function formatCity(row) {
		return row[0] + ", " + row[1] ;
	}

	$("input.city_autocomplete").autocomplete(
	"/cities",
	{
		matchSubset:true,
		matchContains:true,
		cacheLength:1,
		max:100,
		formatResult: formatCity,
		formatItem: formatCity,
	}
	);
	
	//CATEGORY MOUSEOVER
	
	$('li.category_list').mouseover(function(){
		$(this).parent().find("ul").show();
		$(this).find("a.topcategory").addClass("active");
	});
	
	$('li.category_list').mouseout(function(){
		$(this).parent().find("ul").hide();
		$(this).find("a.topcategory").removeClass("active");
	});
	
	// -- 

	$("input#store_name").blur(function(element){
		if($("input#store_name").val() != ""){
			$.getJSON("/stores?index_action=is_unique",{q: $("input#store_name").val()},function(data){
				if(data.length >= 1){
					$("small#store_taken_warning").show();
				}else{
					$("small#store_taken_warning").hide();
				}
			});
		}
	});
	
	$("select#category_mass").change(function(element){
		if($("#category_mass").val() == 0){
			value = prompt('Proporciona el nombre de la categoría');
			if(value!= "" && value != null){
				$.post("/categories", {name: value}, 
					function(data){
						new_category = "<option value='"+ data.id +"' selected='selected'>" +data.name+"</option>";
						add_category_option = $("#category_mass option:last-child");
						$("#category_mass").append(new_category);
						add_category_option.appendTo("#category_mass");
					}, "json");
			}
		}
	});
	
	//Autocomplete
	
	function formatPerson(row) {
		return row[0] + ",<em>" + row[1] + "</em><br />" + row[2] + "," + row[3] + "," + row[4];
	}
	
	function formatResult(row){
		return row[0] + "," + row[1];
	}

	$("#store_sponsor_name").autocomplete(
	"/users",
	{
		matchSubset:true,
		matchContains:true,
		cacheLength:20,
		formatResult: formatResult,
		formatItem:formatPerson,
	}
	);
	
	$("input.add_product_to_cart").click(
		function(element){
			$.post("/cart_items", { product_id: $(this).closest("div").find("input.product_id").val() }, 
			function(data){
				$("div#minicart div.content").html(data);
				$("td#cart_total").effect("highlight", {color: "#fff"}, 1000);
			});
			return false;
	});
	
	$("a.increase_cart_item").click(
		function(){
			$.post("/cart_items/" + $(this).closest("td").find("input").val(), 
				   { update_action: "increase", _method: "put"  }, 
					function(data){
						$( "tr#"+ data.id + " span.item_quantity").html(data.new_quantity);
						$("td#cart_total_price").html(data.new_total);
					}, "json");
			return false;	
	});
	
	$("a.decrease_cart_item").click(
		function(){
			$.post("/cart_items/" + $(this).closest("td").find("input").val(), 
				   { update_action: "decrease", _method: "put"  }, 
					function(data){
						if(parseInt(data.new_quantity) > 0){
							$( "tr#"+ data.id + " span.item_quantity").html(data.new_quantity);
						}else{
							$( "tr#"+ data.id).remove();
							if(data.redirect_cart)
								history.go(-1);
						}
						$("td#cart_total_price").html(data.new_total);
					}, "json");
			return false;	
	});
	
	$("a.remove_item_from_cart").click(
		function(){
			if(confirm("Are you sure?")){
				$.post("/cart_items/" + $(this).closest("tr").find("input").val(), 
					   { _method: "delete"  }, 
						function(data){
							$( "tr#"+ data.id).remove();
							$("td#cart_total_price").html(data.new_total);
							if(data.redirect_cart)
								history.go(-1);
						}, "json");
				return false;
			}
	});
	
	$("input.add_product_to_home").click(function(){
		
		$.post("/products/" + $(this).closest("td").find("input#product_id").val(),
			   {_method: "put", update_type: "home_update", value: $(this).attr("checked")},function(){
			});
	});
	
	$("input#shipping_address_same_for_billing").change(function(){
		if($(this).attr("checked")){
			$("div#billing_address").find("input").attr("disabled","disabled");
			$("div#shipping_address").find("input").change();
		}else{
			$("div#billing_address").find("input").removeAttr("disabled").val("");
		}
	});
	
	$("div#shipping_address input[type=text]").keyup(function(){
		if($("input#shipping_address_same_for_billing").attr('checked'))
			$("#"+ $(this).attr('id').replace("shipping","billing")).val($(this).val());
	});
	
	$("div#shipping_address input[type=text]").change(function(){
		if($("input#shipping_address_same_for_billing").attr('checked'))
			$("#"+ $(this).attr('id').replace("shipping","billing")).val($(this).val());
	});
	
	$("input#upload_csv_file").click(function(){
		$("img#indicator").show();
	});
	
	$("input#new_discount_for_all").click(function(){
		$("img#indicator").show();
	});
	
	$("div#cleft").scrollFollow();
	
	
	$('.rte').rte({
		width: 450,
		height: 200,
		controls_rte: rte_toolbar,
		controls_html: html_toolbar
	        });
	// --
	
});
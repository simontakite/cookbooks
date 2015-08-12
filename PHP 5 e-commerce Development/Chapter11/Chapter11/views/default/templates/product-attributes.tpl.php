<h2>{product_name}</h2>
{product_description}
<p>Cost: &pound;{product_price}, number in stock {product_stock}. Weight: {product_weight}Kg.</p>
<p>
<img src="product_images/{product_image}" alt="{product_name} image" />
</p>
<form action="basket/add-product/{product_path}" method="post">
<!-- START attributes -->
<select name="attribute_{attribute_name}">
<!-- START values_{attribute_name} -->
<option value="{value_id}">{value_name}</option>
<!-- END values_{attribute_name} -->
</select>
<input type="submit" id="add" name="add" value="Add to basket" />
</form>
<!-- END attributes -->
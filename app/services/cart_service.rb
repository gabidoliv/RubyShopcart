class CartService
  def initialize(cart_id)
    @cart = Cart.find_or_create_by(id: cart_id)
  end

  def add_product_to_cart(product_id, quantity)
    product = ProductService.find_by_id(product_id)
    return { error: "Produto não encontrado", status: :not_found } unless product

    cart_item = @cart.cart_items.find_or_initialize_by(product_id: product_id)
    cart_item.quantity += quantity
    cart_item.unit_price = product.price
    calculate_total_price(cart_item)
    cart_item.save!

    {
      id: cart_item.id,
      product_id: cart_item.product_id,
      quantity: cart_item.quantity,
      unit_price: cart_item.unit_price,
      total_price: cart_item.total_price
    }
  end

  def update_item(product_id, quantity)
    cart_item = @cart.cart_items.find_by(product_id: product_id)
    return { error: 'Produto não encontrado no carrinho', status: :not_found } unless cart_item

    cart_item.quantity = quantity
    calculate_total_price(cart_item)
    cart_item.update!

    {
      id: cart_item.id,
      quantity: cart_item.quantity,
      total_price: cart_item.total_price
    }
  end

  def calculate_total_price(cart_item)
    cart_item.total_price = cart_item.quantity * cart_item.unit_price
  end

  def destroy_item(product_id)
    cart_item = @cart.cart_items.find_by(product_id: product_id)
    return { error: 'Produto não encontrado no carrinho', status: :not_found } unless cart_item

    cart_item.destroy
    @cart.reload

    { status: :ok }
  end
end
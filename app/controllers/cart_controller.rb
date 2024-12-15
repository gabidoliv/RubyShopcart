class CartController < ApplicationController
  #POST /cart
  def create
    # Case: verify if the cart already exists and in case it doesn't exist it should create a new one
    session[:cart_id] ||= Cart.create.id
    cart = Cart.find(session[:cart_id])
    

    # Case: verify searching for product to add to the cart
    product = Product.find_by(id: params[:product_id])
    unless product
      return render json: { error: "Carrinho vazio" }, status: :not_found
    end

    # Case: verify adding the product to the cart
    cart_item = cart.cart_items.find_or_initialize_by(product_id: params[:product_id])
    cart_item.quantity ||= 0
    cart_item.quantity += params[:quantity].to_i
    cart_item.unit_price = product.price
    cart_item.total_price = cart_item.quantity * product.price
    cart_item.save!

    # Case: verify that response is a list of products in the cart
    if cart_item.save
      render json: {
        id: cart.id,
        products: cart.cart_items.map do |item|
          {
            id: item.product.id,
            name: item.product.name,
            quantity: item.quantity,
            unit_price: item.product.price.to_f,
            total_price: (item.quantity * item.product.price).to_f
          }
        end,
        total_price: cart.cart_items.sum { |item| item.quantity * item.product.price }.to_f
      }, status: :ok
      else
        render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
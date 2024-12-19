class CartsController < ApplicationController
  def create
    cart_service = CartService.new(session[:cart_id])
    response = cart_service.add_product_to_cart(params[:product_id], params[:quantity].to_i)
    render json: response, status: response.dig(:status) || :ok
  end

  def show
    cart = Cart.find_by(id: params[:id])
    return render json: { error: 'Carrinho não encontrado' }, status: :not_found unless cart

    cart_service = CartService.new(cart.id)
    render json: cart_service.get_cart_items, status: :ok
  end

  def update_item
    cart_service = CartService.new(session[:cart_id])
    response = cart_service.update_item(params[:product_id], params[:quantity])
    render json: response, status: response.dig(:status) || :ok
  end

  def destroy_item
    cart_service = CartService.new(session[:cart_id])
    response = cart_service.destroy_item(params[:product_id])
    render json: response, status: response.dig(:status) || :ok
  end
end
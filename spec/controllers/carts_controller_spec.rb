require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let!(:product) { create(:product) } 

  describe 'POST #create' do
    it 'creates a new cart' do
      post :create, params: { product_id: product.id, quantity: 1 }, session: { cart_id: nil }

      expect(response).to have_http_status(:ok)
      expect(assigns(:cart)).to be_persisted
      expect(assigns(:cart).cart_items.count).to eq(1)
      expect(assigns(:cart).cart_items.first.product_id).to eq(product.id)
    end
  end

  describe 'GET #show' do
    let!(:cart) { create(:cart) }
    let!(:product) { create(:product) }

    before do
      cart_item = cart.cart_items.create!(product_id: product.id, quantity: 2, unit_price: product.price)
    end

    it 'returns the details of the cart' do
      get :show, session: { cart_id: cart.id }

      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(cart.id)
      expect(json_response['products'].count).to eq(1)
      expect(json_response['total_price']).to eq((product.price * 2).to_f)
    end
  end

  describe 'PATCH #update_item' do
    let!(:cart) { create(:cart) }
    let!(:product) { create(:product) }
    let!(:cart_item) { cart.cart_items.create!(product_id: product.id, quantity: 1, unit_price: product.price) }

    it 'updates the quantity of the item in the cart' do
      patch :update_item, params: { product_id: product.id, quantity: 3 }, session: { cart_id: cart.id }

      expect(response).to have_http_status(:ok)
      expect(cart_item.reload.quantity).to eq(3)
      expect(cart_item.reload.total_price).to eq(product.price * 3)
    end
  end

  describe 'DELETE #destroy_item' do
    let!(:cart) { create(:cart) }
    let!(:product) { create(:product) }
    let!(:cart_item) { cart.cart_items.create!(product_id: product.id, quantity: 1, unit_price: product.price) }

    it 'removes an item from the cart' do
      delete :destroy_item, params: { product_id: product.id }, session: { cart_id: cart.id }

      expect(response).to have_http_status(:ok)
      expect(cart.cart_items.count).to eq(0)
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
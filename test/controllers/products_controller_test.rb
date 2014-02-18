require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = create(:product)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get json index" do
    get :index, format: :json
    assert_response :success
  end

  test "should get show" do
    get :show, id: @product
    assert_response :success
  end

  test "should get json show" do
    get :show, id: @product, format: :json
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should create" do
    assert_difference('Product.count') do
      post :create, product: {name: 'Hello'}
    end
    assert_response 302
  end

  test "should json create" do
    assert_difference('Product.count') do
      post :create, product: {name: 'Hello'}, format: :json
    end
    assert_response :created
  end

  test "should json not create" do
    post :create, product: {quantity: 1}, format: :json
    assert_response :unprocessable_entity
  end

  test "should update" do
    patch :update, id: @product, product: {name: 'Hello'}
    assert_redirected_to product_path(@product)
  end

  test "should json update" do
    patch :update, id: @product, product: {name: 'Hello'}, format: :json
    assert_response :accepted
  end

  test "should destroy" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end
    assert_redirected_to products_path
  end

  test "should json destroy" do
    delete :destroy, id: @product, format: :json
    assert_response :ok
    assert response.body == %q[{"status":"ok"}]
  end
end


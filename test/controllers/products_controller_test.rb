require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = create(:product)
    @@products_created ||= false
    unless @@products_created
      5.times do
        create(:product)
      end
      @@products_created = true
    end
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get index sorted" do
    get :index, order_by: :quantity
    assert_response :success
    collection = assigns(:collection)
    assert_not_nil collection
    one_assert_done = false
    (collection.count - 1).times do |i|
      next if collection[i].nil? or collection[i + 1].nil? or collection[i].quantity.nil? or collection[i + 1].quantity.nil?
      assert collection[i].quantity <= collection[i + 1].quantity
      one_assert_done = true
    end
    assert one_assert_done
  end

  test "should get index search" do
    create(:product, name: 'HelloWorld')
    create(:product, name: 'value')
    get :index, q: :name, v: 'HelloWorld', op: :like
    assert_response :success
    collection = assigns(:collection)
    assert_not_nil collection
    assert collection.count > 0
    assert collection.count < Product.count, "The search has not been performed"

    get :index, q: :name, v: 'value', op: :eq
    assert_response :success
    collection = assigns(:collection)
    assert collection.count > 0
    assert collection.count < Product.count, "The search has not been performed"
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
      post :create, product: {name: 'Hello', quantity: 10}
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


require 'test_helper'

module Admin
  class ProductsControllerTest < ActionController::TestCase
    setup do
      @product = create(:product)
    end

    test "should get index" do
      get :index
      assert_response :success
    end

    test "should get show" do
      get :show, id: @product
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

    test "should update" do
      patch :update, id: @product, product: {name: 'Hello'}
      assert_redirected_to admin_product_path(@product)
    end

    test "should destroy" do
      assert_difference('Product.count', -1) do
        delete :destroy, id: @product
      end
      assert_redirected_to admin_products_path
    end
  end
end


require 'test_helper'
require 'faker/name'

class ManagersControllerTest < ActionController::TestCase
  setup do
    @manager = create(:manager)
    @manageable = @manager.managable
  end

  test "should get show" do
    get :show, id: @manager, product_id: @manageable
    assert_response :success
  end

  test "should get new" do
    get :new, product_id: @manageable
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manager, product_id: @manageable
    assert_response :success
  end

  test "should create" do
    post :create, manager: {firstname: 'Hello'}, product_id: @manageable
    assert_response 302
  end

  test "should update" do
    patch :update, id: @manager, manager: {name: 'Hello'}, product_id: @manageable
    assert_redirected_to product_manager_path
  end
end


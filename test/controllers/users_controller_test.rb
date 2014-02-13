require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = create(:user)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: @user
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should create" do
    post :create, user: {name: 'Hello'}
    assert_response 302
  end

  test "should update" do
    patch :update, id: @user, user: {name: 'Hello'}
    assert_redirected_to user_path(@user)
  end

  test "should destroy" do
    delete :destroy, id: @user
    assert_redirected_to users_path
  end
end


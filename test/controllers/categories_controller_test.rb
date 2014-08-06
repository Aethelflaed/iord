require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  setup do
    @category = create(:category)
    @@categories_created ||= false
    unless @@categories_created
      95.times do
        create(:category)
      end
      @@categories_created = true
    end
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get index pages" do
    get :index, offset: 10, limit: 10
    assert_response :success
  end

  test "should get show" do
    get :show, id: @category
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @category
    assert_response :success
  end

  test "should create" do
    assert_difference('Category.count') do
      post :create, category: {name: 'Hello'}
    end
    assert_response 302
  end

  test "should update" do
    patch :update, id: @category, category: {name: 'Hello'}
    assert_redirected_to category_path(@category)
  end

  test "should destroy" do
    assert_difference('Category.count', -1) do
      delete :destroy, id: @category
    end
    assert_redirected_to categories_path
  end
end


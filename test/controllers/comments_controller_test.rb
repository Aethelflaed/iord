require 'test_helper'
require 'iord/hooks'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = create(:comment)
    @product_id = @comment.commentable.id
  end

  test "should get index" do
    get :index, product_id: @product_id
    assert_response :success
  end

  test "should get json index" do
    get :index, product_id: @product_id, format: :json
    assert_response :success
  end

  test "should get show" do
    get :show, product_id: @product_id, id: @comment
    assert_response :success
  end

  test "should get json show" do
    get :show, product_id: @product_id, id: @comment, format: :json
    assert_response :success
  end

  test "should get new" do
    get :new, product_id: @product_id
    assert_response :success
  end

  test "should get edit" do
    get :edit, product_id: @product_id, id: @comment
    assert_response :success
  end

  test "should create" do
    hook_called = false
    Iord::Hooks.register_hook(:comment, :create) do |resource, action|
      assert action == :create
      assert resource.persisted?
      hook_called = true
    end

    assert_difference("Product.find('#{@product_id}').comments.count") do
      post :create, product_id: @product_id, comment: {author_name: 'Hello'}
    end
    assert_response 302
    assert hook_called
  end
  
  test "should update" do
    hook_called = false
    Iord::Hooks.register_hook(:comment, :update) do |resource, action|
      assert action == :update
      assert resource.persisted?
      hook_called = true
    end

    request.path = "/products/#{@product_id}/comments/#{@comment.id}"
    patch :update, id: @comment.id, product_id: @product_id, comment: {author_name: 'World'}
    assert_redirected_to product_comment_path(@comment.commentable, @comment)
    assert hook_called
  end

  test "should destroy" do
    hook_called = false
    Iord::Hooks.register_hook(:comment, :destroy) do |resource, action|
      assert action == :destroy
      assert resource.persisted? == false
      hook_called = true
    end

    assert_difference("Product.find('#{@product_id}').comments.count", -1) do
      delete :destroy, product_id: @product_id, id: @comment
    end
    assert_redirected_to product_comments_path
    assert hook_called
  end
end


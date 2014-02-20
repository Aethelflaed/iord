require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = create(:comment)
    @product_id = @comment.commentable.id
  end

  test "should get index" do
    get :index, product_id: @product_id
    assert_response :success
  end

  test "should get show" do
    get :show, product_id: @product_id, id: @comment
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
    assert_difference("Product.find('#{@product_id}').comments.count") do
      post :create, product_id: @product_id, comment: {author_name: 'Hello'}
    end
    assert_response 302
  end

  test "should update" do
    request.path = "/products/#{@product_id}/comments/#{@comment.id}"
    patch :update, id: @comment.id, product_id: @product_id, comment: {author_name: 'World'}
    assert_redirected_to product_comment_path(@comment.commentable, @comment)
  end

  test "should destroy" do
    assert_difference("Product.find('#{@product_id}').comments.count", -1) do
      delete :destroy, product_id: @product_id, id: @comment
    end
    assert_redirected_to product_comments_path
  end
end


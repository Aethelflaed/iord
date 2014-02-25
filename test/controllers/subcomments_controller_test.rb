require 'test_helper'

class SubcommentsControllerTest < ActionController::TestCase
  setup do
    @subcomment = create(:subcomment)
    @comment = @subcomment.commentable
    @product = @comment.commentable
  end

  test "should get index" do
    get :index, product_id: @product, comment_id: @comment
    assert_response :success
  end

  test "should get json index" do
    get :index, product_id: @product, comment_id: @comment, format: :json
    assert_response :success
  end

  test "should get show" do
    get :show, product_id: @product, comment_id: @comment, id: @subcomment
    assert_response :success
  end

  test "should get json show" do
    get :show, product_id: @product, comment_id: @comment, id: @subcomment, format: :json
    assert_response :success
  end

  test "should get new" do
    get :new, product_id: @product, comment_id: @comment
    assert_response :success
  end

  test "should get edit" do
    get :edit, product_id: @product, comment_id: @comment, id: @subcomment
    assert_response :success
  end

  test "should create" do
    assert_difference("Product.find('#{@product.id}').comments.find('#{@comment.id}').comments.count") do
      post :create, product_id: @product, comment_id: @comment, comment: {author_name: 'Hello'}
    end
    assert_response 302
  end

  test "should update" do
    request.path = "/products/#{@product.id}/comments/#{@comment.id}/comments/#{@subcomment.id}"
    patch :update, id: @subcomment.id, product_id: @product, comment_id: @comment, comment: {author_name: 'World'}
    assert_redirected_to product_comment_comment_path(@product, @comment, @subcomment)
  end

  test "should destroy" do
    assert_difference("Product.find('#{@product.id}').comments.find('#{@comment.id}').comments.count", -1) do
      delete :destroy, product_id: @product, comment_id: @comment, id: @subcomment
    end
    assert_redirected_to product_comment_comments_path(@product, @comment)
  end
end


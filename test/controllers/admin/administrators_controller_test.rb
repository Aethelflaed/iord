require 'test_helper'
require 'faker/name'

module Admin
  class AdministratorsControllerTest < ActionController::TestCase
    setup do
      @admin = create(:administrator)
    end

    test "should get show" do
      get :show, id: @admin
      assert_response :success
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @admin
      assert_response :success
    end

    test "should create" do
      assert_difference('Administrator.count') do
        post :create, administrator: {firstname: 'Hello'}
      end
      assert_response 302
    end

    test "should update" do
      patch :update, id: @admin, administrator: {name: 'Hello'}
      assert_redirected_to admin_administrator_path
    end
  end
end


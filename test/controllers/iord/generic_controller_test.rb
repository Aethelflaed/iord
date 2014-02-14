require 'test_helper'

module Iord
  class GenericControllerTest < ActionController::TestCase
    setup do
      @client = create(:client)
    end

    test "should get index" do
      @request.path = "/clients"
      get :index
      assert_response :success
      assert_select('h1', 'Listing Normal Clients')
    end

    test "should get show" do
      @request.path = "/clients/#{@client.id}"
      get :show, id: @client
      assert_response :success
    end

    test "should get new" do
      @request.path = "/clients/new"
      get :new
      assert_response :success
    end

    test "should get edit" do
      @request.path = "/clients/#{@client.id}/edit"
      get :edit, id: @client
      assert_response :success
    end

    test "should create" do
      @request.path = "/clients"
      assert_difference('Client.count') do
        post :create, client: {firstname: 'Hello'}
      end
      assert_response 302
    end

    test "should update" do
      @request.path = "/clients/#{@client.id}"
      patch :update, id: @client, client: {firstname: 'Hello'}
      assert_redirected_to client_path(@client)
    end

    test "should destroy" do
      @request.path = "/clients/#{@client.id}"
      assert_difference('Client.count', -1) do
        delete :destroy, id: @client
      end
      assert_redirected_to clients_path
    end

    test "admin should get index" do
      @request.path = "/admin/clients"
      get :index
      assert_response :success
      assert_select('h1', 'Listing Admin Clients')
    end

    test "admin should get show" do
      @request.path = "/admin/clients/#{@client.id}"
      get :show, id: @client
      assert_response :success
    end

    test "admin should get new" do
      @request.path = "/admin/clients/new"
      get :new
      assert_response :success
    end

    test "admin should get edit" do
      @request.path = "/admin/clients/#{@client.id}/edit"
      get :edit, id: @client
      assert_response :success
    end

    test "admin should create" do
      @request.path = "/admin/clients"
      assert_difference('Client.count') do
        post :create, client: {firstname: 'Hello'}
      end
      assert_response 302
    end

    test "admin should update" do
      @request.path = "/admin/clients/#{@client.id}"
      patch :update, id: @client, client: {firstname: 'Hello'}
      assert_redirected_to admin_client_path(@client)
    end

    test "admin should destroy" do
      @request.path = "/admin/clients/#{@client.id}"
      assert_difference('Client.count', -1) do
        delete :destroy, id: @client
      end
      assert_redirected_to admin_clients_path
    end
  end

end


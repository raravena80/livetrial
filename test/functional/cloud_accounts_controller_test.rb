require 'test_helper'

class CloudAccountsControllerTest < ActionController::TestCase
  setup do
    @cloud_account = cloud_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cloud_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cloud_account" do
    assert_difference('CloudAccount.count') do
      post :create, :cloud_account => @cloud_account.attributes
    end

    assert_redirected_to cloud_account_path(assigns(:cloud_account))
  end

  test "should show cloud_account" do
    get :show, :id => @cloud_account.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cloud_account.to_param
    assert_response :success
  end

  test "should update cloud_account" do
    put :update, :id => @cloud_account.to_param, :cloud_account => @cloud_account.attributes
    assert_redirected_to cloud_account_path(assigns(:cloud_account))
  end

  test "should destroy cloud_account" do
    assert_difference('CloudAccount.count', -1) do
      delete :destroy, :id => @cloud_account.to_param
    end

    assert_redirected_to cloud_accounts_path
  end
end

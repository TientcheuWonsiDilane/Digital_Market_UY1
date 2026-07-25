require "test_helper"

class StoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @store = stores(:one)
  end

  test "should get index" do
    get stores_url
    assert_response :success
  end

  test "should get new" do
    sign_in users(:three)
    get new_store_url
    assert_response :success
  end

  test "should create store" do
    sign_in users(:three)
    assert_difference("Store.count") do
      post stores_url, params: { store: { description: @store.description, name: @store.name } }
    end

    assert_redirected_to store_url(Store.last)
  end

  test "should show store" do
    get store_url(@store)
    assert_response :success
  end

  test "should get edit" do
    get edit_store_url(@store)
    assert_response :success
  end

  test "should update store" do
    patch store_url(@store), params: { store: { description: @store.description, name: @store.name, user_id: @store.user_id } }
    assert_redirected_to store_url(@store)
  end

  test "should destroy store" do
    assert_difference("Store.count", -1) do
      delete store_url(@store)
    end

    assert_redirected_to stores_url
  end
end

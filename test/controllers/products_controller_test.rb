require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should redirect show to items" do
    get product_url(@product)
    assert_redirected_to items_path
  end
end

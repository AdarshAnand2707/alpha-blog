require "test_helper"

class CreateCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: "john", email: "john@example.com", password: "password", admin: true)
    sign_in_as(@admin_user)
  end

  test "get new category and create new category" do
    get "/categories/new"
    assert_response :success
    assert_difference "Category.count", 1 do
      post categories_path, params: { category: { name: "Sports" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Sports", response.body
  end

  test "get new category and reject invalid category submussion" do
    get "/categories/new"
    assert_response :success
    assert_no_difference "Category.count", 1 do
      post categories_path, params: { category: { name: "" } }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
    assert_select "h4.alert-heading"
  end
end

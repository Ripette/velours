require "test_helper"

class FavorRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get favor_requests_index_url
    assert_response :success
  end

  test "should get new" do
    get favor_requests_new_url
    assert_response :success
  end

  test "should get create" do
    get favor_requests_create_url
    assert_response :success
  end

  test "should get show" do
    get favor_requests_show_url
    assert_response :success
  end
end

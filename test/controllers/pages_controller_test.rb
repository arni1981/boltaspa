require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get scoring" do
    get pages_scoring_url
    assert_response :success
  end
end

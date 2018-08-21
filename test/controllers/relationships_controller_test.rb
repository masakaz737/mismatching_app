require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get relationships_show_url
    assert_response :success
  end

end

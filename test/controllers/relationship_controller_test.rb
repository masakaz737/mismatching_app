require 'test_helper'

class RelationshipControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get relationship_show_url
    assert_response :success
  end

end

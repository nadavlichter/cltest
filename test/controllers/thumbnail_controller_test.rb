require 'test_helper'

class ThumbnailControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get thumbnail_index_url
    assert_response :success
  end

end

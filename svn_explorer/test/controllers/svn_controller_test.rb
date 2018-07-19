require 'test_helper'

class SvnControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get svn_show_url
    assert_response :success
  end

end

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get omniauth" do
    get sessions_omniauth_url
    assert_response :success
  end

end

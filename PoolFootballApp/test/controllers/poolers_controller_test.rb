require 'test_helper'

class PoolersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pooler = poolers(:one)
  end

  test "should get index" do
    get poolers_url
    assert_response :success
  end

  test "should get new" do
    get new_pooler_url
    assert_response :success
  end

  test "should create pooler" do
    assert_difference('Pooler.count') do
      post poolers_url, params: { pooler: { accessLevel: @pooler.accessLevel, email: @pooler.email, favTeam: @pooler.favTeam, name: @pooler.name, pool_id: @pooler.pool_id, refresh_token: @pooler.refresh_token, token: @pooler.token } }
    end

    assert_redirected_to pooler_url(Pooler.last)
  end

  test "should show pooler" do
    get pooler_url(@pooler)
    assert_response :success
  end

  test "should get edit" do
    get edit_pooler_url(@pooler)
    assert_response :success
  end

  test "should update pooler" do
    patch pooler_url(@pooler), params: { pooler: { accessLevel: @pooler.accessLevel, email: @pooler.email, favTeam: @pooler.favTeam, name: @pooler.name, pool_id: @pooler.pool_id, refresh_token: @pooler.refresh_token, token: @pooler.token } }
    assert_redirected_to pooler_url(@pooler)
  end

  test "should destroy pooler" do
    assert_difference('Pooler.count', -1) do
      delete pooler_url(@pooler)
    end

    assert_redirected_to poolers_url
  end
end

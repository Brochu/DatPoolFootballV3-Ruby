require "application_system_test_case"

class PoolersTest < ApplicationSystemTestCase
  setup do
    @pooler = poolers(:one)
  end

  test "visiting the index" do
    visit poolers_url
    assert_selector "h1", text: "Poolers"
  end

  test "creating a Pooler" do
    visit poolers_url
    click_on "New Pooler"

    fill_in "Accesslevel", with: @pooler.accessLevel
    fill_in "Email", with: @pooler.email
    fill_in "Favteam", with: @pooler.favTeam
    fill_in "Name", with: @pooler.name
    fill_in "Pool", with: @pooler.pool_id
    fill_in "Refresh token", with: @pooler.refresh_token
    fill_in "Token", with: @pooler.token
    click_on "Create Pooler"

    assert_text "Pooler was successfully created"
    click_on "Back"
  end

  test "updating a Pooler" do
    visit poolers_url
    click_on "Edit", match: :first

    fill_in "Accesslevel", with: @pooler.accessLevel
    fill_in "Email", with: @pooler.email
    fill_in "Favteam", with: @pooler.favTeam
    fill_in "Name", with: @pooler.name
    fill_in "Pool", with: @pooler.pool_id
    fill_in "Refresh token", with: @pooler.refresh_token
    fill_in "Token", with: @pooler.token
    click_on "Update Pooler"

    assert_text "Pooler was successfully updated"
    click_on "Back"
  end

  test "destroying a Pooler" do
    visit poolers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Pooler was successfully destroyed"
  end
end

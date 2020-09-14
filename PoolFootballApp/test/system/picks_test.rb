require "application_system_test_case"

class PicksTest < ApplicationSystemTestCase
  setup do
    @pick = picks(:one)
  end

  test "visiting the index" do
    visit picks_url
    assert_selector "h1", text: "Picks"
  end

  test "creating a Pick" do
    visit picks_url
    click_on "New Pick"

    fill_in "Pickstring", with: @pick.pickstring
    fill_in "Pool", with: @pick.pool_id
    fill_in "Pooler", with: @pick.pooler_id
    fill_in "Season", with: @pick.season
    fill_in "Week", with: @pick.week
    click_on "Create Pick"

    assert_text "Pick was successfully created"
    click_on "Back"
  end

  test "updating a Pick" do
    visit picks_url
    click_on "Edit", match: :first

    fill_in "Pickstring", with: @pick.pickstring
    fill_in "Pool", with: @pick.pool_id
    fill_in "Pooler", with: @pick.pooler_id
    fill_in "Season", with: @pick.season
    fill_in "Week", with: @pick.week
    click_on "Update Pick"

    assert_text "Pick was successfully updated"
    click_on "Back"
  end

  test "destroying a Pick" do
    visit picks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Pick was successfully destroyed"
  end
end

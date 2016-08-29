require 'test_helper'

class LateManagermentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get late_managerments_index_url
    assert_response :success
  end

  test "should get show" do
    get late_managerments_show_url
    assert_response :success
  end

  test "should get edit" do
    get late_managerments_edit_url
    assert_response :success
  end

end

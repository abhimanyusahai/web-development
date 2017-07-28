require 'test_helper'

class StudentDataControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get student_data_show_url
    assert_response :success
  end

end

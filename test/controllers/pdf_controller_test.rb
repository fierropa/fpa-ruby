require 'test_helper'

class PdfControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pdf_index_url
    assert_response :success
  end

  test "should get compare" do
    get pdf_compare_url
    assert_response :success
  end

end

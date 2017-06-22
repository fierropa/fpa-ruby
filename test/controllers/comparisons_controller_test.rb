require 'test_helper'

class ComparisonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comparison = comparisons(:one)
  end

  test "should get index" do
    get comparisons_url, as: :json
    assert_response :success
  end

  test "should create comparison" do
    assert_difference('Comparison.count') do
      post comparisons_url, params: { comparison: { description: @comparison.description } }, as: :json
    end

    assert_response 201
  end

  test "should show comparison" do
    get comparison_url(@comparison), as: :json
    assert_response :success
  end

  test "should update comparison" do
    patch comparison_url(@comparison), params: { comparison: { description: @comparison.description } }, as: :json
    assert_response 200
  end

  test "should destroy comparison" do
    assert_difference('Comparison.count', -1) do
      delete comparison_url(@comparison), as: :json
    end

    assert_response 204
  end
end

require 'test_helper'

class AveragebillsControllerTest < ActionController::TestCase
  setup do
    @averagebill = averagebills(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:averagebills)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create averagebill" do
    assert_difference('Averagebill.count') do
      post :create, averagebill: { bill: @averagebill.bill, branch_id: @averagebill.branch_id, month: @averagebill.month, user_id: @averagebill.user_id, year: @averagebill.year }
    end

    assert_redirected_to averagebill_path(assigns(:averagebill))
  end

  test "should show averagebill" do
    get :show, id: @averagebill
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @averagebill
    assert_response :success
  end

  test "should update averagebill" do
    patch :update, id: @averagebill, averagebill: { bill: @averagebill.bill, branch_id: @averagebill.branch_id, month: @averagebill.month, user_id: @averagebill.user_id, year: @averagebill.year }
    assert_redirected_to averagebill_path(assigns(:averagebill))
  end

  test "should destroy averagebill" do
    assert_difference('Averagebill.count', -1) do
      delete :destroy, id: @averagebill
    end

    assert_redirected_to averagebills_path
  end
end

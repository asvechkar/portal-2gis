require 'test_helper'

class PlancentsControllerTest < ActionController::TestCase
  setup do
    @plancent = plancents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plancents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plancent" do
    assert_difference('Plancent.count') do
      post :create, plancent: { branch_id: @plancent.branch_id, fromprc: @plancent.fromprc, month: @plancent.month, mult: @plancent.mult, toprc: @plancent.toprc, year: @plancent.year }
    end

    assert_redirected_to plancent_path(assigns(:plancent))
  end

  test "should show plancent" do
    get :show, id: @plancent
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @plancent
    assert_response :success
  end

  test "should update plancent" do
    patch :update, id: @plancent, plancent: { branch_id: @plancent.branch_id, fromprc: @plancent.fromprc, month: @plancent.month, mult: @plancent.mult, toprc: @plancent.toprc, year: @plancent.year }
    assert_redirected_to plancent_path(assigns(:plancent))
  end

  test "should destroy plancent" do
    assert_difference('Plancent.count', -1) do
      delete :destroy, id: @plancent
    end

    assert_redirected_to plancents_path
  end
end

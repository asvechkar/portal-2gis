require 'test_helper'

class FactorsControllerTest < ActionController::TestCase
  setup do
    @factor = factors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:factors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create factor" do
    assert_difference('Factor.count') do
      post :create, factor: { avaragebill: @factor.avaragebill, branch_id: @factor.branch_id, clients: @factor.clients, incomes: @factor.incomes, month: @factor.month, planproc04from: @factor.planproc04from, planproc04to: @factor.planproc04to, planproc06from: @factor.planproc06from, planproc06to: @factor.planproc06to, planproc08from: @factor.planproc08from, planproc08to: @factor.planproc08to, planproc10from: @factor.planproc10from, planproc10to: @factor.planproc10to, planproc12from: @factor.planproc12from, planproc12to: @factor.planproc12to, prepay: @factor.prepay, prolongcent: @factor.prolongcent, proplancor: @factor.proplancor, weight: @factor.weight, year: @factor.year }
    end

    assert_redirected_to factor_path(assigns(:factor))
  end

  test "should show factor" do
    get :show, id: @factor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @factor
    assert_response :success
  end

  test "should update factor" do
    patch :update, id: @factor, factor: { avaragebill: @factor.avaragebill, branch_id: @factor.branch_id, clients: @factor.clients, incomes: @factor.incomes, month: @factor.month, planproc04from: @factor.planproc04from, planproc04to: @factor.planproc04to, planproc06from: @factor.planproc06from, planproc06to: @factor.planproc06to, planproc08from: @factor.planproc08from, planproc08to: @factor.planproc08to, planproc10from: @factor.planproc10from, planproc10to: @factor.planproc10to, planproc12from: @factor.planproc12from, planproc12to: @factor.planproc12to, prepay: @factor.prepay, prolongcent: @factor.prolongcent, proplancor: @factor.proplancor, weight: @factor.weight, year: @factor.year }
    assert_redirected_to factor_path(assigns(:factor))
  end

  test "should destroy factor" do
    assert_difference('Factor.count', -1) do
      delete :destroy, id: @factor
    end

    assert_redirected_to factors_path
  end
end

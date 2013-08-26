require 'test_helper'

class DebtsControllerTest < ActionController::TestCase
  setup do
    @debt = debts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:debts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create debt" do
    assert_difference('Debt.count') do
      post :create, debt: { client_id: @debt.client_id, debtsum: @debt.debtsum, debttype: @debt.debttype, employee_id: @debt.employee_id, month: @debt.month, order_id: @debt.order_id, user_id: @debt.user_id, year: @debt.year }
    end

    assert_redirected_to debt_path(assigns(:debt))
  end

  test "should show debt" do
    get :show, id: @debt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @debt
    assert_response :success
  end

  test "should update debt" do
    patch :update, id: @debt, debt: { client_id: @debt.client_id, debtsum: @debt.debtsum, debttype: @debt.debttype, employee_id: @debt.employee_id, month: @debt.month, order_id: @debt.order_id, user_id: @debt.user_id, year: @debt.year }
    assert_redirected_to debt_path(assigns(:debt))
  end

  test "should destroy debt" do
    assert_difference('Debt.count', -1) do
      delete :destroy, id: @debt
    end

    assert_redirected_to debts_path
  end
end

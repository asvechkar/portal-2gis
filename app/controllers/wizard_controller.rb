class WizardController < ApplicationController
  def clients
    @clients = Client.today(current_user.id).page(params[:clients_page]).per(25)
  end

  def current_orders
    @current_orders = Order.current.today(current_user.id)
                           .page(params[:current_orders_page]).per(25)

    respond_to do |format|
      format.js
    end
  end

  def continue_orders
    @continue_orders = Order.continue.today(current_user.id)
                            .page(params[:continue_orders_page]).per(25)

    respond_to do |format|
      format.js
    end
  end

  def debts
    @debts = Debt.today(current_user.id).page(params[:debts_page]).per(10)

    respond_to do |format|
      format.js
    end
  end

  def plans
    @plans = Plan.today(current_user.id).page(params[:plans_page]).per(10)

    respond_to do |format|
      format.js
    end
  end
end

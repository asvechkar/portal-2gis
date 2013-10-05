class WizardController < ApplicationController
  def clients
    @clients = Client.all.page(params[:clients_page]).per(25)
  end

  def current_orders
    @current_orders = Order.where("finishdate > '#{last_day}'")
                           .page(params[:current_orders_page]).per(25)

    respond_to do |format|
      format.js
    end
  end

  def continue_orders
    @continue_orders = Order.where("finishdate = '#{last_day}'")
                            .page(params[:continue_orders_page]).per(25)

    respond_to do |format|
      format.js
    end
  end

  def debts
    @debts = Debt.all.page(params[:debts_page]).per(10)

    respond_to do |format|
      format.js
    end
  end

  def plans
    @plans = Plan.all.page(params[:plans_page]).per(10)

    respond_to do |format|
      format.js
    end
  end

  private

  def last_day
    @last_day ||= Date.today.at_end_of_month
  end
end

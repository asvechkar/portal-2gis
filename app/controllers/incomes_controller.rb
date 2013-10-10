class IncomesController < ApplicationController
  before_action :set_income, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @incomes = params[:filter] ? Income.filter(params[:filter]) : Income.all
    @employees = params[:filter] && params[:filter][:branch] ? Employee.by_branch(params[:filter][:branch]) : Employee.all
  end

  def get_orders_by_client_id
    select = '<option value="">Выберите бланк-заказ</option>'
    begin
      clients = Client.where(id: params[:id])
      unless clients.empty?
        orders = Order.where(client_id: clients.first.id)
        orders.each do |order|
          select += "<option value='#{order.id}'>#{order.ordernum}</option>"
        end
      end
    rescue Exception => e
      select = '<option value="">Бланков нет</option>'
    end
    render text: select
  end

  def new
    @income = Income.new
  end

  def create
    @income = current_user.incomes.new(income_params)

    respond_to do |format|
      if @income.save
        Tools.write2log(current_user.id, 'Добавление', 'Поступления', 0, income_params.to_s)
        format.html { redirect_to incomes_path, notice: 'Поступление успешно добавлено.' }
        format.json { render action: 'show', status: :created, location: @income }
      else
        Tools.write2log(current_user.id, 'Добавление', 'Поступления', 1, income_params.to_s)
        format.html { render action: 'new' }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @income.update(income_params)
        Tools.write2log(current_user.id, 'Обновление', 'Поступления', 0, income_params.to_s)
        format.html { redirect_to incomes_path, notice: 'Поступление успешно обновлено.' }
        format.json { head :no_content }
      else
        Tools.write2log(current_user.id, 'Обновление', 'Поступления', 1, income_params.to_s)
        format.html { render action: 'edit' }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    Tools.write2log(current_user.id, 'Удаление', 'Поступления', 0, '# ' + @income.id.to_s)
    @income.destroy
    respond_to do |format|
      format.html { redirect_to incomes_url }
      format.json { head :no_content }
    end
  end

  private

  def set_income
    @income = Income.find(params[:id])
  end

  def income_params
    params.require(:income).permit(:indate, :client_id, :insum, :employee_id, :cash, :order_id, :user_id)
  end
end

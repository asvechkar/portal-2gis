# encoding: utf-8
class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /orders
  # GET /orders.json
  def index
    if params[:type] && request.xhr?
      get_filtered_orders
      html = render_to_string(partial: 'orders', layout: false, locals: { orders: @orders })
      render json: { html: html }
    else
      branch = current_employee.branch || Branch.first
      @orders = Order.by_branch(branch).page(params[:page]).per(25)
    end
  end

  def wizard
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_user.orders.new(order_params)
    @order.status = 0
    respond_to do |format|
      if @order.save
        Tools.write2log(current_user.id, 'Добавление', 'Заказы', 0, order_params.to_s)
        format.html { redirect_to orders_path, notice: 'Заказ был успешно добавлен.' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        Tools.write2log(current_user.id, 'Добавление', 'Заказы', 1, order_params.to_s)
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        Tools.write2log(current_user.id, 'Обновление', 'Заказы', 0, order_params.to_s)
        format.html { redirect_to @order, notice: 'Заказ был успешно обновлен.' }
        format.json { head :no_content }
      else
        Tools.write2log(current_user.id, 'Обновление', 'Заказы', 1, order_params.to_s)
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    Tools.write2log(current_user.id, 'Удаление', 'Заказы', 0, '# ' + @order.id.to_s)
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  def set_continue
    @orders = Order.where(id: params[:ids])
    @orders.each do |order|
      order.set_continue
      order.save
    end
    render nothing: true
  end

  private

    def get_filtered_orders
      branch = params[:order_branch] || current_employee.branch
      @orders = Order.by_branch(branch).by_ordernum(params[:order][:ordernum]).by_employee(params[:order_employee])
      @orders = case params[:type]
                when 'current' then @orders.current.page(params[:page]).per(25)
                when 'continue' then @orders.continue.page(params[:page]).per(25)
                else @orders.page(params[:page]).per(25)
                end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:ordernum, :orderdate, :startdate, :finishdate, :status, :ordersum, :continue, :employee_id, :client_id, :user_id, :city_id, :order_id)
    end
end

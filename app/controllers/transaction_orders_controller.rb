# encoding: utf-8

class TransactionOrdersController < ApplicationController

  def new
    @step = params[:step] || 'client'
    @client, @order, @user = Client.new, Order.new, current_user
  end

  def create
    @user = current_user
    case @step = params[:step]
    when 'client'
      action('order')
      render 'new'
    when 'order'
      action('confirm')
      render 'new'
    when 'confirm'
      @client = Client.create(params[:user][:client].permit(:name, :inn, :code))
      @order = Order.create(params[:user][:order].permit(:city_id, :employee_id, :client_id,
        :ordersum, :startdate, :finishdate, :orderdate, :ordernum, :order_id, :continue))
      render 'new', notice: 'Заказ успешно оформлен'
    end
  end

  private

  def action(to)
    @client = Client.new(params[:user][:client].permit(:name, :inn, :code))
    @order = Order.new(params[:user][:order].permit(:city_id, :employee_id, :client_id,
      :ordersum, :startdate, :finishdate, :orderdate, :ordernum, :order_id, :continue))
    @step = to if @client.valid?
  end

end

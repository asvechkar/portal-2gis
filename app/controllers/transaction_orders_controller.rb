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
      transaction_objects
      @step = 'order' if @client.valid?
      render 'new'
    when 'order'
      transaction_objects
      @step = 'confirm' if @order.valid?
      render 'new'
    when 'confirm'
      transaction_objects
      @client.save
      @order.assign_attributes({ client_id: @client.id, continue: 0, status: 0 })
      @order.save
      redirect_to @order, notice: 'Новая продажа успешно оформлена'
    end
  end

  private

  def transaction_objects
    @client = Client.new(params[:user][:client].permit(:name, :inn, :code))
    @order = Order.new(params[:user][:order].merge(user_id: current_user.id, client_id: 1, continue: 0, status: 0)
          .permit(:city_id, :employee_id, :client_id, :ordersum, :startdate, :finishdate, :orderdate, :ordernum,
          :order_id, :continue, :status, :user_id))
  end

end

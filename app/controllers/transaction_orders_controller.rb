class TransactionOrdersController < ApplicationController
  include Wicked::Wizard
  steps :client, :order, :confirm

  def show
    case step
    when :client
      @client = Client.new
      render 'client' and return
    when :order
      @order = Order.new
      render 'order' and return
    end
  end

  def update
    case step
    when :client
      @client = Client.new(params[:client].permit(:name, :inn, :code))
      render_wizard(@client)
    when :orders
      @order = Order.new(params[:order].permit(:name, :inn, :code))
      render 'confirm' and return
    when :confirm
      @order.save
      @client.save
    end
  end

end

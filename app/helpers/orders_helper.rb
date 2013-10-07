# encoding: utf-8

module OrdersHelper
  def wizard_button_name
    case @step
    when 'client'
      'Перейти к шагу 2'
    when 'order'
      'Перейти к шагу 3'
    when 'confirm'
      'Сохранить Новую продажу'
    end
  end
end

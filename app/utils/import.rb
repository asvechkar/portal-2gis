module Import

  def self.xlsx(file, cname, uid)
    sheet = Roo::Excelx.new(file)
    case cname
      when 'client' then log = Import.clients(sheet, uid)
      when 'order_curr' then log = Import.orders(sheet, uid)
      when 'order_cont' then log = Import.orders_cont(sheet, uid)
      when 'debt_inst' then log = Import.installments(sheet, uid)
      when 'debt_debt' then log = Import.debts(sheet, uid)
    end
    return log
  end
  # Функция загрузки рассрочки
  # A - Куратор
  # B - Юр.лицо заказчика
  # C = Планируемый объем оплат (в план)
  def self.installments(sheet, uid)
    message = ''
    count = 0
    sheet.last_row.downto(2) do |row|
      message += 'Новая рассрочка<br />'
      # Получаем сотрудника
      employee_ln = sheet.cell('A', row).to_s.slice(/(^[^,]*)/).strip
      employee_fn = sheet.cell('A', row).to_s.slice(/([^,\s]*[^\s]$)/).strip
      employee_id = Import.whereMyEmployee(employee_ln, employee_fn, uid)
      message += "employee_id = #{employee_id.to_s}<br />"
      # Получает клиента
      client_name = sheet.cell('B', row).to_s
      client_id = Import.getClientByName(client_name, uid)
      message += "client_id = #{client_id.to_s}<br />"
      # Получаем бланк-заказ
      order_id = Order.where(:client_id => client_id, :employee_id => employee_id).first
      message += "order_id = #{order_id.to_s}<br />"
      # Получаем сумму
      installsum = sheet.cell('C', row)
      # Сообщения об ошибке
      message = message + '<br>' + 'Клиент ' + client_name.to_s + ' отсутствует в системе ' if client_id.nil?
      message = message + '<br>' + 'Сотрудник ' + employee_fn.to_s + ' ' + employee_ln.to_s + ' отсутствует в системе' if employee_id.nil?
      # Создание записи
      deb = Debt.create(:year => Date.today.year, :month => Date.today.month, :employee_id => employee_id, :client_id => client_id, :order_id => order_id, :debtsum => installsum, :debttype => 1, :user_id => uid)
      count += 1 if deb
    end
    message = message + '<br><p>' + 'Импортировано ' + count.to_s + ' записей из ' + (sheet.last_row - 1).to_s + '</p>'
    log = Eventlog.create(:user_id => uid, :action => 'Импорт', :model => 'Рассрочка', :status => 0, :message => message)
    return log.id
  end

  def self.debts(sheet, uid)
    message = ''
    count = 0
    sheet.last_row.downto(2) do |row|
      message += 'Новая дебеторская задолженность<br />'
      # Получаем сотрудника
      employee_ln = sheet.cell('A', row).to_s.slice(/(^[^,]*)/).strip
      employee_fn = sheet.cell('A', row).to_s.slice(/([^,\s]*[^\s]$)/).strip
      employee_id = Import.whereMyEmployee(employee_ln, employee_fn, uid)
      message += "employee_id = #{employee_id.to_s}<br />"
      # Получает клиента
      client_name = sheet.cell('B', row).to_s
      client_id = Import.getClientByName(client_name, uid)
      message += "client_id = #{client_id.to_s}<br />"
      # Получаем бланк-заказ
      order_id = Order.where(:client_id => client_id, :employee_id => employee_id).first
      message += "order_id = #{order_id.to_s}<br />"
      # Получаем сумму
      installsum = sheet.cell('C', row)
      # Сообщения об ошибке
      message = message + '<br>' + 'Клиент ' + client_name.to_s + ' отсутствует в системе ' if client_id.nil?
      message = message + '<br>' + 'Сотрудник ' + employee_fn.to_s + ' ' + employee_ln.to_s + ' отсутствует в системе' if employee_id.nil?
      # Создание записи
      deb = Debt.create(:year => Date.today.year, :month => Date.today.month, :employee_id => employee_id, :client_id => client_id, :order_id => order_id, :debtsum => installsum, :debttype => 2, :user_id => uid)
      count += 1 if deb
    end
    message = message + '<br><p>' + 'Импортировано ' + count.to_s + ' записей из ' + (sheet.last_row - 1).to_s + '</p>'
    log = Eventlog.create(:user_id => uid, :action => 'Импорт', :model => 'Дебетовая задолженность', :status => 0, :message => message)
    return log.id
  end

  def self.orders_cont(sheet, uid)
    # сообщения лога
    message = ''
    count = 0
    # проходим всю таблицу от начала и до второй строки
    sheet.last_row.downto(2) { |list|
      # получаем сотрудника
      employee_ln = sheet.cell('A', list).to_s.slice(/(^[^,]*)/).strip
      employee_fn = sheet.cell('A', list).to_s.slice(/([^,\s]*[^\s]$)/).strip
      employee_id = Import.whereMyEmployee(employee_ln, employee_fn, uid)
      # получаем клиента
      client_name = sheet.cell('B', list).to_s
      client_id = Import.whereMyClient(client_name, uid)
      # Получаем город
      city_name = sheet.cell('C', list).to_s
      city_id = Import.getCityByName(city_name, uid)
      # получаем номер заказа из таблицы
      ordernum = sheet.cell('D', list)
      # пишем warning-сообщения в лог
      message = message + '<br>' + 'Клиент ' + client_name.to_s + ' отсутствует в системе:: запись ' + list.to_s + ' не импортирована ' if client_id.nil?
      message = message + '<br>' + 'Сотрудник ' + employee_fn.to_s + ' ' + employee_ln.to_s + ' отсутствует в системе:: запись '  + list.to_s + ' не импортирована ' if employee_id.nil?
      # если все условия соблюдены - создаем запись
      order = Order.create(:employee_id => employee_id,
                           :client_id => client_id,
                           :user_id => uid,
                           :city_id => city_id,
                           :ordernum => ordernum,
                           :ordersum => sheet.cell('E', list),
                           :orderdate => sheet.cell('F', list),
                           :startdate => sheet.cell('F', list),
                           :finishdate => sheet.cell('G', list),
                           :continue => 0,
                           :status => 0) if client_id && Order.where(:ordernum => ordernum).first.nil? && employee_id
      # считаем количество импортированных записей
      count += 1 if order
    }
    message = message + '<br><p>' + 'Импортировано ' + count.to_s + ' записей из ' + (sheet.last_row - 1).to_s + '</p>'
    log = Eventlog.create(:user_id => uid, :action => 'Импорт', :model => 'Продленные заказы', :status => 0, :message => message)
    return log.id
  end

  def self.clients(sheet, uid)
    message = ''
    count = 0
    sheet.last_row.downto(2) { |list|
      (sheet.cell('B', list).to_s.size < 1) ? code = 'NONE' : code = sheet.cell('B', list).to_s.slice(/(^[^,]*)/)
      inn = sheet.cell('C', list)
      inn = '000000000' if inn.nil?
      newclient = Client.create(:name => sheet.cell('A', list), :code => code, :inn => inn, :user_id => uid) unless Client.where(:code => code).first
      count += 1 if newclient
    }
    message = message + '<br><p>' + 'Импортировано ' + count.to_s + ' клиентов из ' + (sheet.last_row - 1).to_s + '</p>'
    log = Eventlog.create(:user_id => uid, :action => 'Импорт', :model => 'Клиенты', :status => 0, :message => message)
    return log.id
  end

  def self.orders(sheet, uid)
    # сообщения лога
    message = ''
    count = 0
    # проходим всю таблицу от начала и до второй строки
    sheet.last_row.downto(2) { |list|
        # получаем сотрудника
        employee_ln = sheet.cell('A', list).to_s.slice(/(^[^,]*)/).strip
        employee_fn = sheet.cell('A', list).to_s.slice(/([^,\s]*[^\s]$)/).strip
        employee_id = Import.whereMyEmployee(employee_ln, employee_fn, uid)
        # получаем клиента
        client_name = sheet.cell('B', list).to_s
        client_id = Import.whereMyClient(client_name, uid)
        # Получаем город
        city_name = sheet.cell('C', list).to_s
        city_id = Import.getCityByName(city_name, uid)
        # получаем номер заказа из таблицы
        ordernum = sheet.cell('D', list)
        # пишем warning-сообщения в лог
        message = message + '<br>' + 'Клиент ' + client_name.to_s + ' отсутствует в системе:: запись ' + list.to_s + ' не импортирована ' if client_id.nil?
        message = message + '<br>' + 'Сотрудник ' + employee_fn.to_s + ' ' + employee_ln.to_s + ' отсутствует в системе:: запись '  + list.to_s + ' не импортирована ' if employee_id.nil?
        # если все условия соблюдены - создаем запись
        order = Order.create(:employee_id => employee_id,
                     :client_id => client_id,
                     :user_id => uid,
                     :city_id => city_id,
                     :ordernum => ordernum,
                     :ordersum => sheet.cell('E', list),
                     :orderdate => sheet.cell('F', list),
                     :startdate => sheet.cell('F', list),
                     :finishdate => sheet.cell('G', list),
                     :continue => 0,
                    :status => 0) if client_id && Order.where(:ordernum => ordernum).first.nil? && employee_id
      # считаем количество импортированных записей
      count += 1 if order
    }
    message = message + '<br><p>' + 'Импортировано ' + count.to_s + ' записей из ' + (sheet.last_row - 1).to_s + '</p>'
    log = Eventlog.create(:user_id => uid, :action => 'Импорт', :model => 'Текущие заказы', :status => 0, :message => message)
    return log.id
  end

  def self.whereMyEmployee(ln, fn, uid)
    employee = Employee.where(:firstname => fn, :lastname => ln).first
    id = nil
    id = employee.id if employee # && employee.groups.first
    return id
  end

  def self.whereMyClient(client_name, uid)
     code = client_name.slice(/(^[^,]*)/)
     client = Client.where(:code => code).first
     id = nil
     id = client.id if client
     return id
  end

  def self.getClientByName(client_name, uid)
    name = client_name.slice(/(^[^,]*)/)
    client = Client.where(:name => name).first
    id = nil
    id = client.id if client
    return id
  end

  def self.getCityByName(city_name, uid)
    city = City.where(:name => city_name).first
    id = city.nil? ? nil : city.id
    return id
  end
end
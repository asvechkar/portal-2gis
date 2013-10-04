module Import
  mattr_accessor :sheet, :uid, :employee_fn, :employee_ln

  def self.xlsx(file, cname, uid)
    sheet = Roo::Excelx.new(file)
    self.sheet, self.uid = sheet, uid
    case cname
      when 'client' then log = Import.clients(sheet, uid)
      when 'order_curr' then log = Import.orders(sheet, uid)
      when 'order_cont' then log = Import.orders_cont(sheet, uid)
      when 'debt_inst' then log = Import.installments(sheet, uid)
      when 'debt_debt' then log = Import.debts(sheet, uid)
      when 'income' then log = income
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
      # Получаем сотрудника
      employee_ln = sheet.cell('A', row).to_s.slice(/(^[^,]*)/).strip
      employee_fn = sheet.cell('A', row).to_s.slice(/([^,\s]*[^\s]$)/).strip
      employee_id = Import.whereMyEmployee(employee_ln, employee_fn, uid)
      # Получает клиента
      client_name = sheet.cell('B', row).to_s
      client_id = Import.getClientByName(client_name, uid)
      # Получаем бланк-заказ
      order_id = Order.where(:client_id => client_id, :employee_id => employee_id).first
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

  # Загрузка дебетовой рассрочки
  def self.debts(sheet, uid)
    message = ''
    count = 0
    sheet.last_row.downto(2) do |row|
      # Получаем сотрудника
      employee_ln = sheet.cell('A', row).to_s.slice(/(^[^,]*)/).strip
      employee_fn = sheet.cell('A', row).to_s.slice(/([^,\s]*[^\s]$)/).strip
      employee_id = Import.whereMyEmployee(employee_ln, employee_fn, uid)
      # Получает клиента
      client_name = sheet.cell('B', row).to_s
      client_id = Import.getClientByName(client_name, uid)
      # Получаем бланк-заказ
      order_id = Order.where(:client_id => client_id, :employee_id => employee_id).first
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

  # Загрузка продлений
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
                           :continue => 1,
                           :status => 0) if client_id && Order.where(:ordernum => ordernum).first.nil? && employee_id
      # считаем количество импортированных записей
      count += 1 if order
    }
    message = message + '<br><p>' + 'Импортировано ' + count.to_s + ' записей из ' + (sheet.last_row - 1).to_s + '</p>'
    log = Eventlog.create(:user_id => uid, :action => 'Импорт', :model => 'Продленные заказы', :status => 0, :message => message)
    return log.id
  end

  # Загрузка клиентов
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

  # Загрузка текущих
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

  #импорт поступлений (A,B,F,H)
  def self.income
    message = ''
    count = 0
    sheet.last_row.downto(2) do |row|
      # Получаем сотрудника
      employee_id = employee_for_row(row)
      # Получает клиента
      client_name = sheet.cell('B', row)
      client_id = Import.getClientByName(client_name, uid)
      # Получаем бланк-заказ
      order_id = Order.find_by(:client_id => client_id, :employee_id => employee_id)
      # Получаем сумму
      indate = sheet.cell('F', row)
      insum = sheet.cell('H', row)
      # Сообщения об ошибке
      message = "#{message}<br>Клиент #{client_name} отсутствует в системе" unless client_id
      message = "#{message}<br>Сотрудник #{employee_fn} #{employee_ln} отсутствует в системе" unless employee_id
      # Создание записи
      count += 1 if Income.create(:indate => indate, :insum => insum)
    end
    message = "#{message}<br><p>Импортировано #{count} записей из #{sheet.last_row - 1}</p>"
    log = Eventlog.create(:user_id => uid, :action => 'Импорт', :model => 'Income - Выгрузка по оплатам', :status => 0, :message => message)
    log.id
  end

  # поиск сотрудника по имени и фамилии
  def self.whereMyEmployee(ln, fn, uid)
    employee = Employee.where(:firstname => fn, :lastname => ln).first
    id = nil
    id = employee.id if employee # && employee.groups.first
    return id
  end

  # поиск клитента по коду
  def self.whereMyClient(client_name, uid)
     code = client_name.slice(/(^[^,]*)/)
     client = Client.where(:code => code).first
     id = nil
     id = client.id if client
     return id
  end

  # поиск клитента по имени
  def self.getClientByName(client_name, uid)
    name = client_name.slice(/(^[^,]*)/)
    client = Client.where(:name => name).first
    id = nil
    id = client.id if client
    return id
  end

  # поиск города по имени
  def self.getCityByName(city_name, uid)
    city = City.where(:name => city_name).first
    id = city.nil? ? nil : city.id
    return id
  end

  private

  def self.employee_for_row(row)
    full_name = sheet.cell('A', row)
    self.employee_ln = full_name.slice(/(^[^,]*)/).strip
    self.employee_fn = full_name.slice(/([^,\s]*[^\s]$)/).strip
    whereMyEmployee(employee_ln, employee_fn, uid)    
  end
end

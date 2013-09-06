module Import

  def self.xlsx(file, cname, uid)
    sheet = Roo::Excelx.new(file)
    case
      when cname == 'client' then log = Import.clients(sheet, uid)
      when cname == 'order' then log = Import.orders(sheet, uid)
    end
    return log
  end


  def self.clients(sheet, uid)
    message = ''
    sheet.last_row.downto(2) { |list|
      (sheet.cell('I', list).to_s.size < 1) ? code = 'NONE' :
          code = sheet.cell('I', list).to_s.slice(/(^[^,]*)/)
      inn = sheet.cell('L', list)
      Client.create(:name => sheet.cell('A', list),
                    :code => code,
                    :inn => inn,
                    :user_id => uid) unless Client.where(:inn => inn).first && inn.size < 1
    }
    log = Eventlog.create(:user_id => uid, :action => 'Import', :model => 'Client', :status => 0, :message => message)
    return log.id
  end

  def self.orders(sheet, uid)
    # сообщения лога
    message = ''
    # счетчик импортированных сообщений
    count = 0
    # проверяем, содержит ли первая колонка список кураторов
    if sheet.cell('A', 1) == 'Куратор'
      # проходим всю таблицу от начала и до второй строки
      sheet.last_row.downto(2) { |list|
          # получаем lastname сотрудника из таблицы
          employee_ln = sheet.cell('A', list).to_s.slice(/(^[^,]*)/).strip
          # получаем firstname сотрудника из таблицы
          employee_fn = sheet.cell('A', list).to_s.slice(/([^,\s]*[^\s]$)/).strip
          # проверяем, есть ли сотрудник в системе и получаем его id
          employee_id = Import.whereMyEmployee(employee_ln, employee_fn, uid)
          # получаем клиента из таблицы
          client_name = sheet.cell('B', list).to_s
          # проверяем, есть ли клиент в системе и получаем его id
          client_id = Import.whereMyClient(client_name, uid)
          # получаем номер  заказа из таблицы
          ordernum = sheet.cell('D', list)
          # пишем warning-сообщения в лог
          message = message + '<br>' + 'Клиент ' + client_name.to_s + ' отсутствует в системе:: запись ' + list.to_s + ' не импортирована ' if client_id.nil?
          message = message + '<br>' + 'Сотрудник ' + employee_fn.to_s + ' ' + employee_ln.to_s + ' отсутствует в системе:: запись '  + list.to_s + ' не импортирована ' if employee_id.nil?
          # проверяем, заведен ли в системе клиент, заведен ли сотрудник и нет ли уже в базе такой записи
          # если все условия соблюдены - создаем запись
          order = Order.create(:employee_id => employee_id,
                       :client_id => client_id,
                       :user_id => uid,
                       :ordernum => ordernum,
                       :orderdate => sheet.cell('F', list),
                       :startdate => sheet.cell('F', list),
                       :finishdate => sheet.cell('G', list),
                       :ordersum => sheet.cell('E', list),
                       :continue => 0,
                      :status => 0) if client_id && Order.where(:ordernum => ordernum).first.nil? && employee_id
        # считаем количество импортированных записей
        count += 1 if order
      }
      message = message + '<br>' + 'Импортировано ' + count.to_s + ' записей из ' + (sheet.last_row - 1).to_s
      log = Eventlog.create(:user_id => uid, :action => 'Import', :model => 'Order', :status => 0, :message => message)
    else
      # если нет - пишем в лог ошибку и завершаем процедуру импорта
      log = Eventlog.create(:user_id => uid, :action => 'Import', :model => 'Order', :status => 1, :message => 'Неправильный формат файла!')
    end
    return log.id
  end

  def self.whereMyEmployee(ln, fn, uid)
    employee = Employee.where(:firstname => fn, :lastname => ln).first
    id = nil
    id = employee.id if employee && employee.groups.first
    return id
  end

  def self.whereMyClient(client_name, uid)
     code = client_name.slice(/(^[^,]*)/)
     client = Client.where(:code => code).first
     id = nil
     id =client.id if client
     return id
  end
end
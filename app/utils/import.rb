module Import

  def self.xlsx(file, cname, uid)
    sheet = Roo::Excelx.new(file)
    case
      when cname == 'client' then Import.clients(sheet, uid)
      when cname == 'order' then Import.orders(sheet, uid)
    end
  end


  def self.clients(sheet, uid)
    sheet.last_row.downto(2) { |list|
      (sheet.cell('I', list).to_s.size < 1) ? code = 'NONE' :
          code = sheet.cell('I', list).to_s.slice(/(^[^,]*)/)
      inn = sheet.cell('L', list)
      Client.create(:name => sheet.cell('A', list),
                    :code => code,
                    :inn => inn,
                    :user_id => uid) unless Client.where(:inn => inn).first && inn.size < 1
    }
  end

  def self.orders(sheet, uid)
    sheet.last_row.downto(2) { |list|
      if sheet.cell('A', list).to_s.size > 1
        employee_ln = sheet.cell('B', list).to_s.slice(/(^[^,]*)/).strip
        employee_fn = sheet.cell('B', list).to_s.slice(/([^,\s]*[^\s]$)/).strip
        employee_id = Import.whereMyEmployee(employee_ln, employee_fn, uid)
        client_name = sheet.cell('C', list).to_s
        client_id = Import.whereMyClient(client_name, uid)
        Order.create(:employee_id => employee_id,
                     :client_id => client_id,
                     :user_id => uid,
                     :ordernum => sheet.cell('E', list),
                     :orderdate => sheet.cell('G', list),
                     :startdate => sheet.cell('G', list),
                     :finishdate => sheet.cell('H', list),
                     :ordersum => sheet.cell('F', list),
                     :continue => 0,
                     :status => 0) if client_id
      end
    }

  end

  def self.whereMyEmployee(ln, fn, uid)
    employee = Employee.where(:firstname => fn, :lastname => ln).first
    if employee
      id = employee.id
    else
      employee = Employee.create!(:firstname => fn,
                              :lastname => ln,
                              :middlename => ' ',
                              :snils => 0,
                              :user_id => uid,
                              :position_id => nil,
                              :level_id => nil )
      id = employee.id
    end
    id
  end

  def self.whereMyClient(client_name, uid)
     code = client_name.slice(/(^[^,]*)/)
     client = Client.where(:code => code).first
    if client
      id =client.id
    else
      #client = Client.create!(:name => client_name,
      #                       :code => code,
      #                       :inn => 0,
      #                       :user_id => uid)
      #id = client.id
      id = nil
    end
    id
  end
end
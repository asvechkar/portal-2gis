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
          code = sheet.cell('I', list).to_s.slice!(/(^[^,]*)/)
      inn = sheet.cell('L', list)
      Client.create(:name => sheet.cell('A', list),
                    :code => code,
                    :inn => inn,
                    :user_id => uid) unless Client.where(:inn => inn).first && inn.size < 1
    }
  end

  def self.orders(sheet, uid)
    sheet.last_row.downto(2) { |list|

    }

  end

  def self.employ

  end
end
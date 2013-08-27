module Import

  def self.xlsx(file, cname)
    sheet = Roo::Excelx.new(file)
    case
      when cname == 'client' then Import.client(sheet)
    end
  end


  def self.client(sheet)
    sheet.last_row.downto(2) { |list|
      (sheet.cell('I', list).to_s.size < 1) ? code = 'NONE' :
          code = sheet.cell('I', list).to_s.slice!(/(^[^,]*)/)
      inn = sheet.cell('L', list)
      Client.create(:name => sheet.cell('A', list),
                    :code => code,
                    :inn => inn ) unless Client.where(:inn => inn).first && inn.size < 1
    }
  end
end
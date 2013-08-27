module Import

  def self.xlsx(file, cname)
    sheet = Roo::Excelx.new(file)
  end

end
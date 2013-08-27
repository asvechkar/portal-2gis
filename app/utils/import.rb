module Import

  def self.xlsx(file, cname)
    sheet = Roo::Excelx.new("#{Rails.root}/public" + file)
  end

end
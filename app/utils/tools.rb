module Tools

  def self.write2log user_id, action, model, status, message
    log = Eventlog.create(:user_id => user_id, :action => action, :model => model, :status => status, :message => message)
    return log.id
  end

  def self.status_list
    {
      'Открыт' => 0,
      'Закрыт' => 1,
      'Отказ' => 2
    }
  end
end
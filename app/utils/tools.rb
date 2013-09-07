module Tools
  def self.write2log user_id, action, model, status, message
    log = Eventlog.create(:user_id => user_id, :action => action, :model => model, :status => status, :message => message)
    return log.id
  end
end
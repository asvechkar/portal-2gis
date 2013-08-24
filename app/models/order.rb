class Order < ActiveRecord::Base
  belongs_to :employee
  belongs_to :client
  belongs_to :user
  validates_presence_of :ordernum, :orderdate, :startdate, :finishdate, :status, :ordersum, :continue, :employee, :client, :user

  def status_desc
    case self.status
      when 0 then 'Открыт'
      when 1 then 'Закрыт'
      else 'Аннулирован'
    end
  end

  def continue_desc
    case self.continue
      when 0 then 'нет'
      when 1 then 'да'
      else 'нет'
    end
  end
end

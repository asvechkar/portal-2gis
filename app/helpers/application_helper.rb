module ApplicationHelper
  def page_title
    @page_title || 'Управление'
  end

  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=72"
  end

  def months_list
    {
      'Январь' => 1,
      'Февраль' => 2,
      'Март' => 3,
      'Апрель' => 4,
      'Май' => 5,
      'Июнь' => 6,
      'Июль' => 7,
      'Август' => 8,
      'Сентябрь' => 9,
      'Октябрь' => 10,
      'Ноябрь' => 11,
      'Декабрь' => 12
    }
  end

  def years_list
    {
      Date.today.year.to_s => Date.today.year,
      (Date.today.year + 1).to_s => Date.today.year + 1,
      (Date.today.year + 2).to_s => Date.today.year + 2
    }
  end
end

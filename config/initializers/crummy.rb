Crummy.configure do |config|
  config.format = :html_list
  config.ul_class = :breadcrumb
  devider = "<li class='divider'></li>"
  config.html_list_separator = devider.html_safe
end
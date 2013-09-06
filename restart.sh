kill -9 `cat /var/run/unicorn/portal2gis.leondr.pid` && rvm use 2.0.0 do bundle exec unicorn_rails -Dc /etc/unicorn/portal2gis.leondr.rb

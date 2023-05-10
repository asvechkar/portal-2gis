#!/bin/bash
set -e

bundle exec rake db:migrate

rm -f tmp/pids/server.pid

bundle exec rails s -p 3000 -b '0.0.0.0'
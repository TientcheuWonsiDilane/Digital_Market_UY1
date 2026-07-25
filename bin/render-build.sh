#!/usr/bin/env bash
# Exit on error
set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean

# If you have a paid instance type, move this line to the
# Pre-Deploy Command instead (see below).
bin/rails db:migrate
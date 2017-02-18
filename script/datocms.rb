#!/usr/bin/env ruby
require 'dotenv'
Dotenv.load

exec("bundle exec dato dump --token=#{ENV['DATO_READ_API']}")

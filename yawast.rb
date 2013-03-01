#!/usr/bin/env ruby

require 'uri'
require 'resolv'
require './scanner/scan-core'
require './colorization'

VERSION = '0.0.1'
HTTP_UA = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0; YAWAST/#{VERSION})"

def header
  puts "YAWAST v #{VERSION}"
  puts 'Copyright (c) 2013 Adam Caudill <adam@adamcaudill.com>'
  puts ''
end

def usage
  puts './yawast.rb <url>'
  exit(-1)
end

def puts_msg(type, msg)
  puts "#{type} #{msg}"
end

def puts_error(msg)
  puts_msg('[E]'.red, msg)
end

def puts_vuln(msg)
  puts_msg('[V]'.pink, msg)
end

def puts_warn(msg)
  puts_msg('[W]'.yellow, msg)
end

def puts_info(msg)
  puts_msg('[I]'.green, msg)
end

#start the execution flow
header
usage if ARGV.count != 1

#make sure ARGV[0] is a URL
begin
  uri = URI.parse(ARGV[0])
  
  #see if we can resolve the host
  dns = Resolv::DNS.new()
  addr = dns.getaddress(uri.host)

  uri.path = '/' if uri.path == ''

  puts "Scanning: #{uri.to_s} (#{addr})..."
  puts ''

  #we made it this far, so we should be good to go
  scan(uri)
rescue => e
  puts_error "Invalid URL (#{e.message})"
  usage
end

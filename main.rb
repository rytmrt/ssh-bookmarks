# ruby
require 'optparse'
require 'yaml'

PROJCT_ROOT    = File.expand_path(File.dirname(__FILE__))
HOST_LIST_PATH = "#{PROJCT_ROOT}/hostlist.yaml"
HOST_LIST = YAML.load_file(HOST_LIST_PATH)

def showHostList
  puts '---------- host list ----------'
  puts HOST_LIST.keys
  puts '-------------------------------'
  exit
end

option={}
OptionParser.new do |opt|
  opt.on('-l', '--list', 'Show host list') {|v| option[:list] = v}
  opt.on('-n VALUE', '--name VALUE', 'Connect host name') {|v| option[:host] = v}
  opt.parse!(ARGV)
end

if ! File.exist?(HOST_LIST_PATH) then
  puts "Not exist '#{HOST_LIST_PATH}/hostlist.yaml'."
  puts "Please create or copy '#{HOST_LIST_PATH}/hostlist.yaml.sample'."
  exit
end

if option[:list] then
  showHostList()
end

if option[:host] then
  hostName = option[:host]
  if HOST_LIST.key?(hostName) then
    host = HOST_LIST[hostName]
    sshStr = "ssh #{host[:user]}@#{host[:host]} -p #{host[:port]}"
    if host.key?(:ssh_key) then
      sshStr = "#{sshStr} -i #{host[:ssh_key]}"
    end
    exec(sshStr)
  else
    puts "No exist name."
    showHostList()
  end
end

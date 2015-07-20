require 'trollop'
require 'thread'
require 'json'

require_relative 'screen_shotter.rb'

opts = Trollop::options do
  version 'Nyx 0.0.1 (c) 2015 Klaus Horn'
  banner <<-EOS
Screen shot tool for android phones using adb.
Usage:
        nyx [options]
where [options] are:
  EOS
  opt :nyx_json, 'Screen shot description .json', :default => ''    # string --nyx-json=PATH, default is nil
  opt :save_dir, 'Screen shot save directory', :default => './temp' # string --save-dir=PATH
end
Trollop::die :nyx_json, 'Must be declared' unless opts[:nyx_json]
Trollop::die :nyx_json, 'Must be a json file' unless opts[:nyx_json].to_s[-5..-1] == '.json'

SAVE_FOLDER = opts[:save_dir]

begin
  JSON_FILE = File.read(opts[:nyx_json])
  SCREEN_PARAMS = JSON.parse(JSON_FILE, :symbolize_names => true)
rescue StandardError => e
  abort("Failed to parse json file. Exception:\n#{e}, \nbacktrace: #{e.backtrace}")
end

def print_json
  lines =  JSON_FILE.split('\n')
  lines.each { |line| puts line}
end

def print_status
  SCREEN_PARAMS[:screen_shots].each { |sc|
    if File.exist?("#{SAVE_FOLDER}/#{sc[:dir_name]}/#{sc[:filename]}.png")
      puts "[x]\tfilename: #{sc[:filename]}"
    else
      puts "[ ]\tfilename: #{sc[:filename]}"
    end
  }
end




def run!
  puts SCREEN_PARAMS
  user_choice = nil
  until user_choice == 0
    system('cls')
    p '0 : Exit'
    p '1 : Print .json file'
    p '2 : Print status'
    p '3 : Take screen shot'
    user_choice = gets.chomp.to_i
    case user_choice
      when 0
        break

      when 1
        print_json
        gets

      when 2
        print_status
        gets

      when 3
        gets
      else


    end
  end
end


run! if __FILE__==$0
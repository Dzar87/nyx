require 'fileutils'

class ScreenShotter
  attr_accessor :save_dir, :filename

  # Not really necessary
  def initialize(screen_shot_dir=nil, filename=nil)
    @save_dir = screen_shot_dir
    @filename = filename
  end

  def take_screen_shot(screen_shot_dir=nil, filename=nil)

    save_path = File.join('./temp/', screen_shot_dir)

    if screen_shot_dir
      unless screen_shot_dir[-1] == '/'
        save_path = File.join(save_path, '/')
      end
    end

    @save_dir = save_path
    filename ? @filename = filename : @filename = 'screen_shot_' + Time.now.strftime('%Y-%m-%d')

    unless File.directory?(@save_dir)
      FileUtils.mkdir_p @save_dir
    end

    self.adb_cmd(%Q[adb shell screencap -p /sdcard/#{filename}.png])
    self.adb_cmd(%Q[adb pull /sdcard/#{filename}.png #{@save_dir}#{filename}.png])
    self.adb_cmd(%Q[adb shell rm /sdcard/#{filename}.png])

    true
  end

  private
  # adb_cmd should be given as a %Q string
  def adb_cmd(command)
    begin
      IO.popen(command) { |f| f.read }
    rescue Exception => e
      puts "Tried to send command: #{command} but got an exception:\n#{e}, Backtrace #{e.backtrace}"
    end
  end
end
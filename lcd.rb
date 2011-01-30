#!/Users/light/.rvm/rubies/ruby-1.9.2-p0/bin/ruby

ZERO =<<HERE
 -- 
|  |
|  |
    
|  |
|  |
 -- 
HERE

ONE = <<HERE
    
   |
   |
    
   |
   |
    
HERE

class Lcdizer
  attr_accessor :size, :digit

  def initialize
    self.size = 2
  end

  def run
    parse_cmdline
    case self.digit
    when 0
      render_zero
    when 1
      puts ONE
    else
      # no-op
    end
  end

  def parse_cmdline
    while arg = ARGV.shift
      self.size = ARGV.shift.to_i if arg == "-s"
      self.digit = arg.to_i
    end
  end

  def render_zero
    print " "
    self.size.times { print "-" }
    puts " " 

    self.size.times do
      print "|"
      self.size.times { print " " }
      print "|"
      puts
    end

    (self.size + 2).times { print " " }
    puts

    self.size.times do
      print "|"
      self.size.times { print " " }
      print "|"
      puts
    end

    print " "
    self.size.times { print "-" }
    puts " " 
  end
end

at_exit do
  Lcdizer.new.run
end

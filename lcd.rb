#!/Users/light/.rvm/rubies/ruby-1.9.2-p0/bin/ruby

class NumberRenderer
  attr_reader :size

  def initialize(size)
    @size = size
  end

  def horizontal_line
    print " "
    self.size.times do
      print "-"
    end
    puts
  end
end

class ZeroRenderer < NumberRenderer
  def vertical_lines
    self.size.times do
      print "|"
      self.size.times { print " " }
      print "|"
      puts
    end
  end

  def render
    horizontal_line
    vertical_lines
    puts
    vertical_lines
    horizontal_line
  end
end

class OneRenderer < NumberRenderer
  def opposing_vertical_lines
    self.size.times do
      (self.size + 1).times { print " " }
      puts "|"
    end
  end

  def render
    puts 
    opposing_vertical_lines
    puts
    opposing_vertical_lines
    puts
  end
end

class TwoRenderer < NumberRenderer
  def right_edge
    self.size.times do
      (self.size + 1).times { print " " }
      puts "|"
    end
  end

  def left_edge
    self.size.times do
      puts "|"
    end
  end

  def render
    horizontal_line
    right_edge
    horizontal_line
    left_edge
    horizontal_line
  end
end

class Lcdizer
  attr_accessor :size, :digit

  def initialize
    self.size = 2
  end

  NUM_TO_NUM_NAME_MAP = { 
    0 => "Zero",
    1 => "One",
    2 => "Two"
  }

  def run
    parse_cmdline
    klass_name = "#{NUM_TO_NUM_NAME_MAP[self.digit]}Renderer"
    klass = Module.const_get(klass_name)
    klass.new(size).render
  end

  def parse_cmdline
    while arg = ARGV.shift
      self.size = ARGV.shift.to_i if arg == "-s"
      self.digit = arg.to_i
    end
  end
end

at_exit do
  ARGV << "0" if ARGV.empty?
  Lcdizer.new.run 
end

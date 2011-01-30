#!/Users/light/.rvm/rubies/ruby-1.9.2-p0/bin/ruby

class NumberRenderer
  attr_reader :size

  def self.register(number, &block)
    @number_to_strategy_map ||= {}
    @number_to_strategy_map[number] = block
  end

  def self.renderer_for(number)
    @number_to_strategy_map[number]
  end

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

  def opposing_vertical_lines
    self.size.times do
      print "|"
      self.size.times { print " " }
      print "|"
      puts
    end
  end

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

  def render(value)
    instance_eval &(self.class.renderer_for(value))
  end
end

def define_renderer_for(number, &block)
  NumberRenderer.register(number, &block)
end

define_renderer_for 0 do
  horizontal_line
  opposing_vertical_lines
  puts
  opposing_vertical_lines
  horizontal_line
end

define_renderer_for 1 do
  puts 
  right_edge
  puts
  right_edge
  puts
end

define_renderer_for 2 do
  horizontal_line
  right_edge
  horizontal_line
  left_edge
  horizontal_line
end

define_renderer_for 3 do
  horizontal_line
  right_edge
  horizontal_line
  right_edge
  horizontal_line
end

define_renderer_for 4 do
  puts
  opposing_vertical_lines
  horizontal_line
  right_edge
  puts
end

define_renderer_for 5 do
  horizontal_line
  left_edge
  horizontal_line
  right_edge
  horizontal_line
end

define_renderer_for 6 do
  horizontal_line
  left_edge
  horizontal_line
  opposing_vertical_lines
  horizontal_line
end

define_renderer_for 7 do
  horizontal_line
  right_edge
  puts
  right_edge
  puts
end

define_renderer_for 8 do
  horizontal_line
  opposing_vertical_lines
  horizontal_line
  opposing_vertical_lines
  horizontal_line
end

define_renderer_for 9 do
  horizontal_line
  opposing_vertical_lines
  horizontal_line
  right_edge
  horizontal_line
end

class Lcdizer
  attr_accessor :size, :digit

  def initialize
    self.size = 2
  end

  def run
    parse_cmdline
    NumberRenderer.new(size).render(digit)
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

#!/Users/light/.rvm/rubies/ruby-1.9.2-p0/bin/ruby

class NumberRenderer
  attr_reader :size

  def initialize(size)
    @size = size
  end
end

class ZeroRenderer < NumberRenderer
  def horizontal_line
    print " "
    self.size.times { print "-" }
    puts 
  end

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
  def vertical_lines
    self.size.times do
      (self.size + 1).times { print " " }
      puts "|"
    end
  end

  def render
    puts 
    vertical_lines
    puts
    vertical_lines
    puts
  end
end

class TwoRenderer < NumberRenderer
  def horizontal_line
    print " "
    self.size.times do
      print "-"
    end
    puts
  end

  def right_edge
    self.size.times do
      (self.size + 1).times { print " " }
      puts "|"
    end
  end

  def left_edge
    puts "|"
  end

  def vertical_edge_on_side(side_name = :left)
    self.size.times do
      row = "|"
      (self.size + 1).times { row << " " }
      row.reverse! if side_name == :right
      row.send(:rstrip!) if side_name == :left
      puts row
    end
  end
  
  def render
    horizontal_line
    vertical_edge_on_side :right
    horizontal_line
    vertical_edge_on_side :left
    horizontal_line
  end
end

class Lcdizer
  attr_accessor :size, :digit

  def initialize
    self.size = 2
  end

  def run
    parse_cmdline
    case self.digit
    when 0
      ZeroRenderer.new(size).render
    when 1
      OneRenderer.new(size).render
    when 2
      TwoRenderer.new(size).render
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
end

at_exit do
  Lcdizer.new.run
end

#!/Users/light/.rvm/rubies/ruby-1.9.2-p0/bin/ruby

class NumberRenderer
  attr_reader :size

  def self.register(number, strategy)
    @number_to_strategy_map ||= {}
    @number_to_strategy_map[number] = strategy
  end

  def self.strategy_for(number)
    @number_to_strategy_map[number]
  end

  def initialize(size)
    @size = size
  end

  def horizontal_line
    line = " "
    self.size.times { line << "-" }
    line << " "
  end

  def opposing_vertical_lines
    line = "|"
    self.size.times { line << " " }
    line << "|"
  end

  def right_edge
    line = ""
    (self.size + 1).times { line << " " }
    line << "|"
  end

  def left_edge
    line = "|"
    (self.size + 1).times { line << " " }
    line
  end

  def blank_line
    line = ""
    (self.size + 2).times { line << " " }
    line
  end

  def render(digits)
    lcd_lines = []
    [:top_line, :top, :middle, :btm, :btm_line].each do |part_to_render|
      if [:top, :btm].include? part_to_render
        size.times { render_lcd_line_for digits, :for => part_to_render } 
      else
        render_lcd_line_for digits, :for => part_to_render
      end
    end
  end

  def render_lcd_line_for(digits, args = {})
    line = ""
    digits.each do |digit|
      render_strategy = self.class.strategy_for(digit)
      line_for_number = self.send(render_strategy.send(args[:for]))
      line << line_for_number
    end
    puts line
  end
end

class RendererStrategy < Struct.new(:top_line, :top, :middle, :btm, :btm_line)
end

def define_render_process_for(number, &block)
  NumberRenderer.register(number, RendererStrategy.new(*(block.call)))
end

define_render_process_for 0 do
  [:horizontal_line, :opposing_vertical_lines, :blank_line, :opposing_vertical_lines, :horizontal_line]
end

define_render_process_for 1 do
  [:blank_line, :right_edge, :blank_line, :right_edge, :blank_line]
end

define_render_process_for 2 do
  [:horizontal_line, :right_edge, :horizontal_line, :left_edge, :horizontal_line]
end

define_render_process_for 3 do
  [:horizontal_line, :right_edge, :horizontal_line, :right_edge, :horizontal_line]
end

define_render_process_for 4 do
  [:blank_line, :opposing_vertical_lines, :horizontal_line, :right_edge, :blank_line]
end

define_render_process_for 5 do
  [:horizontal_line, :left_edge, :horizontal_line, :right_edge, :horizontal_line]
end

define_render_process_for 6 do
  [:horizontal_line, :left_edge, :horizontal_line, :opposing_vertical_lines, :horizontal_line]
end

define_render_process_for 7 do
  [:horizontal_line, :right_edge, :blank_line, :right_edge, :blank_line]
end

define_render_process_for 8 do
  [:horizontal_line, :opposing_vertical_lines, :horizontal_line, :opposing_vertical_lines, :horizontal_line]
end

define_render_process_for 9 do
  [:horizontal_line, :opposing_vertical_lines, :horizontal_line, :right_edge, :horizontal_line]
end

class Lcdizer
  attr_accessor :size, :digits

  def initialize
    self.size = 2
  end

  def run
    parse_cmdline
    NumberRenderer.new(size).render(digits)
  end

  def parse_cmdline
    while arg = ARGV.shift
      self.size = ARGV.shift.to_i if arg == "-s"
      self.digits = []
      arg.scan(/\d/) { |d| self.digits << d.to_i }
    end
  end
end

at_exit do
  ARGV << "0" if ARGV.empty?
  Lcdizer.new.run 
end

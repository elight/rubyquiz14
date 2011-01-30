$: << '.'

require 'minitest/autorun'
require 'lcd'

class LcdTest < MiniTest::Unit::TestCase
    ZERO_SIZE_1 = <<HERE
 - 
| |
   
| |
 - 
HERE

    ONE_SIZE_1 = <<HERE
   
  |
   
  |
   
HERE

    ZERO_SIZE_2 = <<HERE
 -- 
|  |
|  |
    
|  |
|  |
 -- 
HERE

    ZERO_SIZE_3 = <<HERE
 --- 
|   |
|   |
|   |
     
|   |
|   |
|   |
 --- 
HERE

    ONE_SIZE_2 = <<HERE
    
   |
   |
    
   |
   |
    
HERE
  
    NUMBERS_MAPPED_TO_SIZE_2_LCDS = {
      0 => ZERO_SIZE_2,
      1 => ONE_SIZE_2
    }

    NUMBERS_MAPPED_TO_SIZE_1_LCDS = {
      0 => ZERO_SIZE_1,
      1 => ONE_SIZE_1
    }

  NUMBERS_MAPPED_TO_SIZE_2_LCDS.each do |number, size_2_lcd|
    define_method("test_#{number}_read_from_argv_renders_correctly_at_default_of_size_2") do
      out = `./lcd.rb #{number}`
      assert_equal size_2_lcd, out
    end
  end

  NUMBERS_MAPPED_TO_SIZE_1_LCDS.each do |number, size_1_lcd|
    define_method("test_#{number}_read_from_argv_renders_correctly_at_size_1") do
      out = `./lcd.rb -s 1 #{number}`
      assert_equal size_1_lcd, out
    end
  end

  def test_0_read_from_argv_renders_correctly_at_size_3
    out = `./lcd.rb -s 3 0`
    assert_equal ZERO_SIZE_3, out
  end

  def test_parse_cmdline_with_0
    lcd = Lcdizer.new
    @expected = 0
    ARGV << @expected.to_s

    lcd.parse_cmdline

    assert_equal @expected, lcd.digit
  end

  def test_parse_cmdline_with_a_size_supplied_correctly_parses_the_digit
    lcd = Lcdizer.new
    @expected = 1
    ARGV << "-s"
    ARGV << "2"
    ARGV << @expected.to_s

    lcd.parse_cmdline

    assert_equal @expected, lcd.digit
  end

  def test_parse_cmdline_with_a_size_supplied_correctly_parses_the_size
    lcd = Lcdizer.new
    @expected = 2
    ARGV << "-s"
    ARGV << @expected.to_s
    ARGV << "1"

    lcd.parse_cmdline

    assert_equal @expected, lcd.size
  end

end

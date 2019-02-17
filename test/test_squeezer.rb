require 'test/unit'
require 'stringio'

require_relative '../lib/formatter'
require_relative '../lib/squeezer'

class TestSqueezer < Test::Unit::TestCase
  def test_end_with_prefix
    system("true")
    status = $?
    out = StringIO.new
    prev_sq = sq = nil
    3.times {|n|
      fmt = Formatter.new(2, "A", out)
      sq = Squeezer.new(prev_sq, fmt)
      sq.start
      sq.output_data("a" * (3-n))
      sq.show_status status
      sq.last_linebreak
      prev_sq = sq
    }
    sq.force_output
    assert_equal("A aaa\nA aa\nA a\n", out.string)
  end
end

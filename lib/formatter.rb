class Formatter
  def initialize(indent_len, title, out=STDOUT)
    @indent_len = indent_len
    @indent = ' ' * indent_len
    @title = title
    @out = out
    @beginning = true
    @after_newline = false
    @content = String.new
    @status = nil
  end
  attr_reader :content, :status

  def start
    @out.print @title.ljust(@indent_len)
  end

  def output_data(s)
    return if s == ''
    @content << s
    s.each_line {|line|
      if @after_newline
        @out.print @indent
        @after_newline = false
      end
      @out.print line
      if /\n\z/ =~ line
        @after_newline = true
      end
    }
    @beginning = false
  end

  def show_status(status)
    if status.to_i != 0
      if !@beginning
        @out.puts if !@after_newline
        @out.print ' ' * (@indent_len-4)
      end
      @out.puts status.inspect
      @after_newline = true
    end
  end

  def last_linebreak
    @out.puts if !@after_newline
  end

  def output_dots
    @out.puts '...'
  end
end

class Formatter
  def initialize(indent_len, title)
    @indent_len = indent_len
    @indent = ' ' * indent_len
    @title = title
    @beginning = true
    @after_newline = false
    @content = String.new
    @status = nil
  end
  attr_reader :content, :status

  def start
    print @title.ljust(@indent_len)
  end

  def output_data(s)
    return if s == ''
    @content << s
    s.each_line {|line|
      if @after_newline
        print @indent
        @after_newline = false
      end
      print line
      if /\n\z/ =~ line
        @after_newline = true
      end
    }
    @beginning = false
  end

  def show_status(status)
    if status.to_i != 0
      if !@beginning
        puts if !@after_newline
        print ' ' * (@indent_len-4)
      end
      puts status.inspect
      @after_newline = true
    end
  end

  def last_linebreak
    puts if !@after_newline
  end
end

class Squeezer
  def initialize(prev_sq, fmt)
    @prev_sq = prev_sq
    @fmt = fmt
    @shown = prev_sq.nil? || $opt_all_ruby_show_dup
    @content = String.new
    @status = nil
  end
  attr_reader :prev_sq, :content, :status, :shown

  def drop_prev
    @prev_sq = nil
  end

  def difference_found
    if @prev_sq
      @prev_sq.force_output
    end
    @shown = true
  end

  def start
    if @prev_sq &&
       @prev_sq.prev_sq &&
       @prev_sq.prev_sq.prev_sq
      if @prev_sq.prev_sq.prev_sq.shown &&
         !@prev_sq.prev_sq.shown &&
         !@prev_sq.shown
        @fmt.output_dots
      end
      @prev_sq.prev_sq.drop_prev
    end
    return @fmt.start if @shown
  end

  def output_data(s)
    @content << s
    return @fmt.output_data(s) if @shown
    return if @prev_sq.content.start_with? @content
    difference_found
    @fmt.start
    @fmt.output_data(@content)
  end

  def show_status(status)
    @status = status
    return @fmt.show_status(status) if @shown
    return if @prev_sq.content == @content &&
              @prev_sq.status == status
    difference_found
    @fmt.start
    @fmt.output_data(@content)
    @fmt.show_status(@status)
  end

  def last_linebreak
    return @fmt.last_linebreak if @shown
  end

  def force_output
    return if @shown
    if @prev_sq &&
       @prev_sq.prev_sq &&
       @prev_sq.prev_sq.shown &&
       !@prev_sq.shown
      @fmt.output_dots
    end
    @shown = true
    @fmt.start
    @fmt.output_data(@content)
    @fmt.show_status(@status)
    @fmt.last_linebreak
  end
end

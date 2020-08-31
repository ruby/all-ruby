VERSION_WORD_NUMBER = {
  'ruby' => 0,
  'preview' => -2,
  'rc' => -1,
  'p' => 1,
  'a' => 1,
  'b' => 2,
  'c' => 3,
  'd' => 4,
  'repack' => 1,
}

def vercmp_key(n)
  return [] if /\A[0-9]/ !~ n
  ary = []
  n.scan(/(\d+)|[a-z]+/m) {
    if $1
      ary << $1.to_i
    else
      n = VERSION_WORD_NUMBER[$&]
      if n
        ary << n
      else
        warn "unexpected word: #{$&.inspect}"
      end
    end
  }
  # [1,8,2] < [1,8,2,-2] but [1,8,2,-2,0,...] < [1,8,2,0,...]
  10.times { ary << 0 }
  ary
end

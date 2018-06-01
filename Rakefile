#!/usr/bin/ruby

# Rakefile - installs historic ruby.
#
# Copyright (C) 2014 Tanaka Akira  <akr@fsij.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above
#     copyright notice, this list of conditions and the following
#     disclaimer in the documentation and/or other materials provided
#     with the distribution.
#  3. The name of the author may not be used to endorse or promote
#     products derived from this software without specific prior
#     written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# This Rakefile installs historic ruby.
#
# rake          : shows the number of rubies to be install
# rake list     : shows the versions to be install
# rake all      : install all versions
# rake VERSION  : install specific version

# This Rakefile assumes Debian GNU/Linux amd64.
#
# Ruby didn't support 64bit environment until Ruby 1.8.0.
# So 32bit compilation tools are required to install older Ruby.
#
#   sudo dpkg --add-architecture i386
#   sudo aptitude install gcc-multilib \
#     zlib1g:i386 libncurses5:i386 libgdbm3:i386 libssl1.0.0:i386 \
#     libreadline6:i386 libffi5:i386

require 'open-uri'
require 'fileutils'
require 'json'
require 'pp'
require 'digest'

def show_help_message
  puts "\"rake all\" will install #{RubySource::TABLE.length} ruby"
  puts "\"rake list\" shows versions"
  puts "\"rake sync\" updates versions.json"
end

URI_BASE = 'https://cache.ruby-lang.org/pub/ruby/'
#URI_BASE = 'ftp://ftp.ruby-lang.org/pub/ruby/'

def make_entry(relpath)
  uri = URI_BASE + relpath
  dir, fn = File.split(relpath)
  version = fn.dup
  prefix = suffix = ''
  prefix = $& if version.sub!(/\Aruby-/, '')
  suffix = $& if version.sub!(/\.tar\.(gz|bz2|xz)\z/, '')
  {
    :relpath => relpath,
    :uri => uri,
    :dir => dir,
    :fn => fn,
    :prefix => prefix,
    :version => version,
    :suffix => suffix,
  }
end

def hashize_version_entry(v)
  h = {}
  case v
  when String
    h[:relpath] = v
  when Hash
    v.each {|k, v|
      h[k.intern] = v
    }
  else
    raise "unexpected entry: #{v.inspect}"
  end
  h
end

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
  return [] if /\Aruby-[0-9]/ !~ n
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
  10.times { ary << 0 }
  ary
end

def ruby_branch(fn)
  case fn
  when /\Aruby-0\./; 0
  when /\Aruby-1\.0/; 1
  when /\Aruby-1\.1a/; 2
  when /\Aruby-1\.1b/; 3
  when /\Aruby-1\.1c/; 4
  when /\Aruby-1\.1d/; 5
  when /\Aruby-1\.2/; 6
  when /\Aruby-1\.3/; 7
  when /\Aruby-1\.4/; 8
  when /\Aruby-1\.6/; 9
  when /\Aruby-1\.8\.[0-4]/; 10
  when /\Aruby-1\.8\.5/; 11
  when /\Aruby-1\.8\.6/; 12
  when /\Aruby-1\.8\.7/; 13
  when /\Aruby-1\.9\.0/; 14
  when /\Aruby-1\.9\.1/; 15
  when /\Aruby-1\.9\.2/; 16
  when /\Aruby-1\.9\.3/; 17
  when /\Aruby-2\.0/; 18
  when /\Aruby-2\.1/; 19
  when /\Aruby-2\.2/; 20
  when /\Aruby-2\.3/; 21
  when /\Aruby-2\.4/; 22
  when /\Aruby-2\.5/; 23
  when /\Aruby-2\.6/; 24
  when /\Aruby-(\d+)\.(\d+)/; $1.to_i * 100 + $2.to_i
  else -1
  end
end

class RubySource

  TARBALLS = JSON.load(File.read("versions.json"))

  table = []
  TARBALLS.each {|ary|
    ary.each {|v|
      h = hashize_version_entry(v)
      next if h.has_key?(:enable) && !h[:enable]
      h.update make_entry(h[:relpath])
      h[:i] = ruby_branch(h[:fn])
      h[:j] = vercmp_key(h[:fn].sub(/\.tar.*/, ''))
      table << h
    }
  }
  TABLE = table.sort_by {|h| [h[:i], h[:j]] }

  def self.dirs
    result = RubySource::TABLE.map {|h|
      h[:uri].sub(%r{/[^/]*\z}, '/')
    }.uniq
    case URI_BASE
    when /\A(http:|https:)/
      index = URI(URI_BASE).read
      lst = []
      index.scan(%r{href="(\d\.\d)/"}) {
        lst << $1
      }
    else
      raise "unexpected URI_BASE scheme: #{URI_BASE} (http/https required)"
    end
    lst.each {|n|
      uri = URI_BASE + n + "/"
      next if result.include? uri
      #puts "New directory found: #{uri}"
      result << uri
    }
    result
  end

  def self.fuzzy_lookup(arg)
    TABLE.each {|h|
      if h[:relpath] == arg ||
         h[:fn] == arg ||
         h[:prefix] + h[:version] == arg ||
         h[:version] == arg
        return h
      end
    }
    nil
  end

  def self.version_lookup(version)
    TABLE.each {|h|
      if h[:version] == version
        return h
      end
    }
    nil
  end

  def initialize(arg)
    @h = RubySource.fuzzy_lookup(arg)
    if !@h
      raise "table lookup failed: #{arg.inspect}"
    end
  end

  def version
    @h[:version]
  end

  def dirname
    @h[:version]
  end

  def filename
    @h[:fn]
  end

  def uri
    @h[:uri]
  end

  def obtain_tarball(dstname)
    tmpname = "#{dstname}.tmp"
    FileUtils.mkpath File.dirname(dstname)
    unless File.file? dstname
      puts "download #{dstname}"
      URI(uri).open {|src|
        open(tmpname, "w") {|dst|
          IO.copy_stream(src, dst)
        }
        File.rename tmpname, dstname
      }
    end
    dstname
  end

  def extract_tarball(filename)
    filename = File.realpath(filename)
    FileUtils.mkpath dirname
    ary = Dir.glob("#{dirname}/*/ruby.c")
    if !ary.empty?
      ary.each {|fn|
        FileUtils.rmtree File.dirname(fn)
      }
    end
    # Assume recent GNU tar which recognize compression automatically.
    system "tar", "xf", filename, :chdir => dirname
    ary = Dir.glob("#{dirname}/*/ruby.c")
    if ary.empty?
      raise "no ruby.c found."
    end
    if 1 < ary.length
      raise "multiple ruby.c found."
    end
    File.basename(File.dirname(ary[0]))
  end

  def obtain_source
    create_directory
    obtain_tarball
    extract_tarball
  end

  def version_eq(version)
    @h[:version] == version
  end

  def local_version_cmp(version)
    arg_hash = RubySource.version_lookup(version)
    raise "version not found: #{version.inspect}" if !arg_hash
    return nil if @h[:i] != arg_hash[:i]
    @h[:j] <=> arg_hash[:j]
  end

  def local_version_lt(version)
    ret = local_version_cmp(version)
    return nil if ret.nil?
    ret < 0
  end

  def local_version_le(version)
    ret = local_version_cmp(version)
    return nil if ret.nil?
    ret <= 0
  end

  def local_version_ge(version)
    ret = local_version_cmp(version)
    return nil if ret.nil?
    ret >= 0
  end

  def local_version_between(v1, v2)
    # inclusive.
    ret1 = local_version_cmp(v1)
    return nil if ret1.nil?
    ret2 = local_version_cmp(v2)
    return nil if ret2.nil?
    return false if ret1 < 0
    return false if ret2 > 0
    true
  end

  def global_version_eq(version)
    arg_hash = RubySource.version_lookup(version)
    raise "version not found: #{version.inspect}" if !arg_hash
    @h[:i] == arg_hash[:i]
  end

  def global_version_cmp(version)
    arg_hash = RubySource.version_lookup(version)
    raise "version not found: #{version.inspect}" if !arg_hash
    @h[:i] <=> arg_hash[:i]
  end

  def global_version_lt(version)
    ret = global_version_cmp(version)
    return nil if ret.nil?
    ret < 0
  end

  def global_version_ge(version)
    ret = global_version_cmp(version)
    return nil if ret.nil?
    ret >= 0
  end

  def run_command(tag, command, prefixdir)
    FileUtils.mkpath "#{prefixdir}/log"
    log_fn = "#{prefixdir}/log/#{tag}.txt"
    status_fn = "#{prefixdir}/log/#{tag}.status"
    print "#{tag} #{version}\n"
    if command.last.kind_of? Hash
      opt = command.last.dup
      command = command[0...-1]
    else
      opt = {}
    end
    opt[[:out, :err]] = [log_fn, "w"]
    system(*command, opt)
    status = $?
    open(status_fn, "w") {|f| f.puts status.to_s.sub(/\Apid \d+ /, '') }
    print "fail #{tag} #{version}\n" if !status.success?
    status.success?
  end

  def patch(srcdir, name)
    prefix = File.realpath(dirname)
    patch = File.realpath("patch/#{name}.diff")
    command = ["patch", "-p0", :in => patch, :chdir => "#{dirname}/#{srcdir}"]
    return false if !run_command("patch-#{name}", command, prefix)
  end

  def modify_file(fn)
    content0 = File.read(fn)
    content = content0.dup
    content = yield content
    if content != content0
      File.write("#{fn}.org", content0)
      File.write(fn, content)
    end
  end

  def apply_workaround(srcdir)
    unless global_version_ge('2.4.0')
      # OpenSSL 1.1.0 is supported since Ruby 2.4.0.
      dir = "#{dirname}/#{srcdir}/ext/openssl"
      File.rename "#{dir}/extconf.rb", "#{dir}/extconf.rb-" if File.exist? "#{dir}/extconf.rb"
      File.rename "#{dir}/MANIFEST", "#{dir}/MANIFEST-" if File.exist? "#{dir}/MANIFEST"
    end
    if version_eq('1.9.3-p426')
      patch srcdir, 'signal-unistd'
    end
    if local_version_between('1.9.1-preview2', '1.9.1-p0')
      patch srcdir, "cont-elif"
    end
    if global_version_eq('1.8.5') ||
       local_version_le('1.8.6-p230') ||
       local_version_le('1.8.7-p22')
      patch srcdir, "math-define-erange"
    end
    if local_version_between('1.3.3-990430', '1.3.3-990430')
      patch srcdir, 'rbconfig-expand'
    end
    if version_eq('1.1d0')
      patch srcdir, 'extmk-heredoc'
    end
    if version_eq('1.1b9_07')
      patch srcdir, 'instruby-dll'
    end
    if local_version_ge('0.99.4-961224') ||
       global_version_eq('1.0-961225') ||
       global_version_eq('1.1a0') ||
       local_version_le('1.1b9_19')
      patch srcdir, 'glob-alloca'
    end
    if local_version_le('0.95')
      patch srcdir, 'glob-alloca2'
    end
    if local_version_le('0.55')
      patch srcdir, 'ruby-errno3'
    elsif local_version_le('0.76')
      patch srcdir, 'ruby-errno2'
    elsif version_eq('0.95')
      patch srcdir, 'ruby-errno'
    end
    if local_version_le('0.95')
      modify_file("#{dirname}/#{srcdir}/configure") {|content|
        content.gsub(/LDSHARED='ld'/, "LDSHARED='gcc -shared'")
      }
    end
    if local_version_le('0.76')
      modify_file("#{dirname}/#{srcdir}/configure") {|content|
        content.gsub(/^pow\(\)/, "pow(1.0, 1.0)")
      }
    end
    parse_y_fn = "#{dirname}/#{srcdir}/parse.y"
    if File.file?(parse_y_fn)
      parse_y_orig = File.read(parse_y_fn)
      parse_y = parse_y_orig.dup
      parse_y.sub!(/^arg\t\t: variable '=' {\$\$ = assignable\(\$1, 0\);} arg$/,
                   "arg\t\t: variable '=' {$<node>$ = assignable($1, 0);} arg")
      parse_y.sub!(/^\t\t\| variable tOP_ASGN \{\$\$ = assignable\(\$1, 0\);\} arg$/,
                   "\t\t| variable tOP_ASGN {$<node>$ = assignable($1, 0);} arg")
      if parse_y_orig != parse_y
        open(parse_y_fn, "w") {|f| f.print parse_y }
      end
    end
    if version_eq('1.3.2-990413')
      dir = "#{dirname}/#{srcdir}/ext/nkf"
      File.rename "#{dir}/extconf.rb", "#{dir}/extconf.rb-" if File.exist? "#{dir}/extconf.rb"
      File.rename "#{dir}/MANIFEST", "#{dir}/MANIFEST-" if File.exist? "#{dir}/MANIFEST"
    end
    if global_version_lt('1.1b0') || local_version_lt('1.1b9_19')
      convert_varargs_to_stdarg "#{dirname}/#{srcdir}"
    end
    if local_version_between('1.1b9_05', '1.1b9_09')
      src = File.read(parse_y_fn)
      src.gsub!(/default:\n( *\})/) { "default: break;\n#{$1}" }
      File.write(parse_y_fn, src)
    end
    if version_eq('1.1b7')
      patch srcdir, 'parse-semicolon'
    end
    if version_eq('1.1b3')
      patch srcdir, 'rb_type-definition'
    end
    if version_eq('1.1b0')
      patch srcdir, 'tcltklib-extconf'
    end
    if version_eq('1.1a4')
      patch srcdir, 'variable-break'
    end
    if local_version_le('0.50')
      patch srcdir, 'error-error2'
    elsif local_version_le('0.76')
      patch srcdir, 'error-error'
    end
    if local_version_le('0.76')
      modify_file("#{dirname}/#{srcdir}/io.c") {|content|
        content.gsub!(/->_gptr/, "->_IO_read_ptr")
        content.gsub!(/->_egptr/, "->_IO_read_end")
        content
      }
    end
    if local_version_le('0.49')
      patch srcdir, 'struct-va_end2'
    elsif local_version_le('0.76')
      patch srcdir, 'struct-va_end'
    end
    if local_version_le('0.49')
      patch srcdir, 'time-time2'
    elsif local_version_le('0.76')
      patch srcdir, 'time-time'
    end
    if version_eq('0.73')
      patch srcdir, 'makefile-assoc'
    end
    if local_version_le('0.69')
      patch srcdir, 'defines-nodbm'
    end
    if version_eq('0.69')
      patch srcdir, 'regex-re_match_2'
    end
    if local_version_le('0.54')
      patch srcdir, 'gnuglob-alloca2'
    elsif local_version_le('0.65')
      patch srcdir, 'gnuglob-alloca'
    end
    if local_version_le('0.60')
      patch srcdir, 'gnuglob-dirent'
    end
    if global_version_lt('1.8.0')
      :build_ruby32
    else
      :build_ruby
    end
  end

  def convert_varargs_to_stdarg(dir)
    funcs = {}
    Dir.glob("#{dir}/*.c").each {|fn|
      src = File.binread(fn)
      next if /^\#include <stdarg\.h>\n/ =~ src
      next if /^\#include <varargs\.h>\n/ !~ src
      File.write("#{fn}.org", src)
      src.gsub!(/^#include <varargs.h>\n/, <<-End.gsub(/^\s*/, ''))
        #ifdef __STDC__
        #include <stdarg.h>
        #define va_init_list(a,b) va_start(a,b)
        #else
        #include <varargs.h>
        #define va_init_list(a,b) va_start(a)
        #endif
      End
      src.gsub!(/^([A-Za-z][A-Za-z0-9_]*)\((.*), va_alist\)\n(( .*;\n)*)( +va_dcl\n)(\{.*\n(.*\n)*?\})/) {

        func = $1
        fargs = $2
        decls = $3
        body = $6
        decl_hash = {}
        decls.each_line {|line|
          line.gsub!(/^ +|;\n/, '')
          n = line.scan(/[a-z_][a-z_0-9]*/)[-1]
          decl_hash[n] = line
        }
        fargs.gsub!(/[a-z_][a-z_0-9]*/) {
          n = $&
          decl_hash[n] || "int #{n}"
        }
        stdarg_decl = "#{func}(#{fargs}, ...)"
        funcs[func] = stdarg_decl
        lastarg = stdarg_decl.scan(/[a-z_][a-z_0-9]*/)[-1]
        body.gsub!(/va_start\(([a-z]+)\)/) { "va_init_list(#{$1}, #{lastarg})" }
        stdarg_decl + "\n" + body
      }
      if fn == "#{dir}/error.c"
        src.gsub!(/^extern void TypeError\(\);/, '/* extern void TypeError(); */')
        src.gsub!(/^ *void ArgError\(\);/, '/* void ArgError(); */')
        src.gsub!(/va_start\(args\);/, 'va_start(args, fmt);')
      end
      src.gsub!(/^\#ifdef __GNUC__\nstatic volatile voidfn/, "\#if 0\nstatic volatile voidfn")
      File.write("#{fn}+", src)
      File.write(fn, src)
    }
    %w[intern.h ruby.h].each {|header|
      fn = "#{dir}/#{header}"
      next unless File.file? fn
      h = File.read(fn)
      File.write("#{fn}.org", h)
      funcs.each {|func, stdarg_decl|
        h.gsub!(/ #{func}\(\);/) { " #{stdarg_decl};" }
      }
      h.gsub!(/^\#ifdef __GNUC__\ntypedef void voidfn/, "\#if 0\ntypedef void voidfn")
      h.gsub!(/^\#ifdef __GNUC__\nvolatile voidfn/, "\#if 0\nvolatile voidfn")
      File.write(fn, h)
    }
  end

  def which(command)
    ENV['PATH'].split(/:/).each {|dir|
      c = "#{dir}/#{command}"
      if File.executable? c
        return c
      end
    }
    nil
  end

  def build_ruby32(srcdir)
    prefix = File.realpath(dirname)
    print "build #{version}\n"

    gcc = which('gcc')
    raise "gcc not found." if !gcc

    FileUtils.mkpath "#{prefix}/bin"
    FileUtils.mkpath "#{prefix}/lib"
    FileUtils.mkpath "#{prefix}/man/man1"

    %w[gcc cc].each {|cc_bin|
      File.open("#{prefix}/bin/#{cc_bin}", "w") {|f|
        f.puts "#!/bin/sh"
        f.puts "#{gcc} -m32 -std=gnu89 \"$@\""
      }
      File.chmod(0755, "#{prefix}/bin/#{cc_bin}")
    }

    setup = [{'CFLAGS'=>'-g -O0',
              'PATH' => "#{prefix}/bin:#{ENV['PATH']}"},
             'setarch', 'i686']

    if local_version_le('0.60')
      setup[0]['LIBS'] = '-lcrypt'
    end

    command = [*setup, "./configure", "--prefix=#{prefix}", :chdir => "#{dirname}/#{srcdir}"]
    if !run_command("configure", command, prefix)
      raise "fail configure #{version}"
    end

    command = [*setup, "make", :chdir => "#{dirname}/#{srcdir}"]
    if !run_command("make", command, prefix)
      raise "fail make #{version}"
    end

    command = [*setup, "make", "install", :chdir => "#{dirname}/#{srcdir}"]
    if !run_command("install", command, prefix)
      raise "fail install #{version}"
    end
  end

  def build_ruby(srcdir)
    prefix = File.realpath(dirname)
    print "build #{version}\n"

    command = ["./configure", "--prefix=#{prefix}", :chdir => "#{dirname}/#{srcdir}"]
    if !run_command("configure", command, prefix)
      raise "fail configure #{version}"
    end

    command = ["make", :chdir => "#{dirname}/#{srcdir}"]
    if !run_command("make", command, prefix)
      raise "fail make #{version}"
    end

    command = ["make", "install", :chdir => "#{dirname}/#{srcdir}"]
    if !run_command("install", command, prefix)
      raise "fail install #{version}"
    end
  end

end

task :default do
  show_help_message
end

task :list do
  puts RubySource::TABLE.map {|h| h[:version] }
end

multitask :all => RubySource::TABLE.map {|h| h[:version] }.reverse
task :allseq => RubySource::TABLE.map {|h| h[:version] }.reverse

RubySource::TABLE.each {|h|
  source = RubySource.new(h[:version])

  task h[:version] => "bin/ruby-#{h[:version]}"

  file "bin/ruby-#{h[:version]}" => "#{h[:version]}/bin/ruby" do |t|
    FileUtils.mkpath File.dirname(t.name)
    unless File.exist? "#{h[:version]}/bin/ruby"
      raise "ruby binary not exist"
    end
    File.symlink "../#{h[:version]}/bin/ruby", "bin/ruby-#{h[:version]}"
  end

  file "#{h[:version]}/bin/ruby" => "DIST/#{h[:fn]}" do |t|
    srcdir = source.extract_tarball("DIST/#{h[:fn]}")
    method = source.apply_workaround(srcdir)
    source.send(method, srcdir)
  end

  file "DIST/#{h[:fn]}" do |t|
    source.obtain_tarball("DIST/#{h[:fn]}")
  end
}

def extract_entries(index_html)
  hs = []
  index_html.scan(/<a href="(.*?)">/) {
    uri = (index_html.base_uri + $1).to_s
    next unless uri.start_with? URI_BASE
    relpath = uri[URI_BASE.length..-1]
    next if relpath.empty?
    h = make_entry(relpath)
    next if h[:suffix].empty?
    hs << h
  }
  hs
end

def filter_suffix(hs)
  hs.group_by {|h| [h[:prefix], h[:version]] }.map {|_, hh|
    hh.sort_by {|h|
      case h[:suffix]
      when ".tar.gz" then 0
      when ".tar.bz2" then 1
      when ".tar.xz" then 2
      else -1
      end
    }[-1]
  }
end

def common_prefix_length(str1, str2)
  if str2.length < str1.length
    str1, str2 = str2, str1
  end
  str1.length.times {|i|
    if str1[i] != str2[i]
      return i
    end
  }
  str1.length
end

def add_version(versions, relpath)
  prefix_length_list = versions.map {|ary|
    ary.map {|v|
      h = hashize_version_entry(v)
      return if relpath == h[:relpath]
      common_prefix_length(relpath, h[:relpath])
    }.max
  }
  target_list_index = (0...prefix_length_list.length).max_by {|i| prefix_length_list[i] }
  if %r{/} =~ relpath && %r{/} !~ relpath[0, prefix_length_list[target_list_index]]
    versions << [relpath]
  else
    versions[target_list_index] << relpath
  end
  puts "versions.json : #{relpath} added."
end

def update_versions(relpath_list)
  return if relpath_list.empty?
  content1 = File.read("versions.json")
  versions = JSON.load(content1)
  relpath_list.each {|relpath|
    add_version versions, relpath
  }
  content2 = JSON.pretty_generate(versions)
  if content1 != content2
    open("versions.json.new", "w") {|f|
      f.puts content2
    }
    #system("diff -u versions.json versions.json.new")
    File.rename("versions.json.new", "versions.json")
  end
end

task 'sync' do
  dirs = RubySource.dirs
  dirs.reverse_each {|dir|
    puts dir
    index_html = URI(dir).read
    hs = extract_entries(index_html)
    hs = filter_suffix(hs)
    relpath_list = hs.map {|h| h[:relpath] }
    update_versions relpath_list
  }
end

def longest_common_substring_of ary
  return ary[0].slice 0, ary.min_by(&:length).length.times {|i|
    break i if ary.any? {|j|
      break true if j[i] != ary[0][i]
    }
  }
end

RubySource::TARBALLS.each do |versions|
  ary = versions.reject {|i| Hash === i }
  str = longest_common_substring_of ary
  str.sub!(%r{.+/ruby-}, '')
  str.sub!(%r{-[\w.]*?$|\.$}, '')
  ary.map! {|v| hashize_version_entry(v) }
  ary.map! {|h| h[:relpath] }
  ary.map! {|r| make_entry(r) }
  ary.map! {|h| h[:version] }
  ary.reverse!
  multitask "all-#{str}" => ary
  task "allseq-#{str}" => ary
end

def expand(dir)
  Dir.open(dir) do |d|
    return (d.to_a - [".", ".."])   \
      .to_enum                      \
      .lazy                         \
      .sort                         \
      .reverse_each                 \
      .map {|i| File.join(dir, i) } \
      .to_a
  end
end

def same?(f1, s1, f2, s2)
  return false unless s1.dev  == s2.dev
  return true  if     s1.ino  == s2.ino # hard link already
  return false unless s1.mode == s2.mode
  return false unless s1.uid  == s2.uid
  return false unless s1.gid  == s2.gid
  return false unless s1.size == s2.size
  return false unless FileUtils.cmp(f1, f2)

  STDOUT.printf "%s -> %s\n", f1, f2 if $DEBUG
  FileUtils.link(f1, f2, force: true)
  return true
end

def try_dedup(target, stat, files)
  d = Digest::SHA1.file(target).digest
rescue SystemCallError
  # EPERM etc., unable to dedup
  puts $! if $DEBUG
else
  STDOUT.printf "%-.79s \r", target + " " * 80 if $VERBOSE and $STDOUT.isatty
  files[d] << [target, stat] unless files[d].any? do |(f, s)|
    same?(target, stat, f, s)
  end
end

task :dedup do
  targets = RubySource::TABLE.map {|h| h[:version] }
  files   = Hash.new {|h, k| h[k] = [] }
  while target = targets.shift do
    begin
      stat = File.lstat(target)
    rescue SystemCallError
      puts $! if $DEBUG
      next
    end

    case stat.ftype
    when "file"      then try_dedup(target, stat, files)
    when "directory" then targets.replace expand(target).concat(targets) # recur
    when "link"      then # OK, already
    else
      raise "unknown file type #{stat.ftype} got for: #{target}"
    end
  end
  puts
end

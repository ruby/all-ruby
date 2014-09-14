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
require 'pp'

class RubySource

  URI_BASE = 'ftp://ftp.ruby-lang.org/pub/ruby/'

  TARBALLS = [
    [
      '1.0/ruby-0.49.tar.gz',
      '1.0/ruby-0.50.tar.gz',
      '1.0/ruby-0.51.tar.gz',
      '1.0/ruby-0.54.tar.gz',
      '1.0/ruby-0.55.tar.gz',
      '1.0/ruby-0.60.tar.gz',
      #'1.0/ruby-0.62.tar.gz', # not in gzip format
      #'1.0/ruby-0.63.tar.gz', # not in gzip format
      '1.0/ruby-0.64.tar.gz',
      '1.0/ruby-0.65.tar.gz',
      '1.0/ruby-0.69.tar.gz',
      '1.0/ruby-0.71.tar.gz',
      '1.0/ruby-0.73.tar.gz',
      '1.0/ruby-0.73-950413.tar.gz',
      '1.0/ruby-0.76.tar.gz',
      '1.0/ruby-0.95.tar.gz',
      '1.0/ruby-0.99.4-961224.tar.gz',
      '1.0/ruby-1.0-961225.tar.gz',
      '1.0/ruby-1.0-971002.tar.gz',
      '1.0/ruby-1.0-971003.tar.gz',
      '1.0/ruby-1.0-971015.tar.gz',
      '1.0/ruby-1.0-971021.tar.gz',
      '1.0/ruby-1.0-971118.tar.gz',
      '1.0/ruby-1.0-971125.tar.gz',
      '1.0/ruby-1.0-971204.tar.gz',
      '1.0/ruby-1.0-971209.tar.gz',
      '1.0/ruby-1.0-971225.tar.gz',
    ],
    %w[
      1.1a/ruby-1.1a0.tar.gz
      1.1a/ruby-1.1a1.tar.gz
      1.1a/ruby-1.1a2.tar.gz
      1.1a/ruby-1.1a3.tar.gz
      1.1a/ruby-1.1a4.tar.gz
      1.1a/ruby-1.1a5.tar.gz
      1.1a/ruby-1.1a6.tar.gz
      1.1a/ruby-1.1a7.tar.gz
      1.1a/ruby-1.1a8.tar.gz
      1.1a/ruby-1.1a9.tar.gz
    ],
    %w[
      1.1b/ruby-1.1b0.tar.gz
      1.1b/ruby-1.1b1.tar.gz
      1.1b/ruby-1.1b2.tar.gz
      1.1b/ruby-1.1b3.tar.gz
      1.1b/ruby-1.1b4.tar.gz
      1.1b/ruby-1.1b5.tar.gz
      1.1b/ruby-1.1b6.tar.gz
      1.1b/ruby-1.1b7.tar.gz
      1.1b/ruby-1.1b8.tar.gz
      1.1b/ruby-1.1b9.tar.gz
      1.1b/ruby-1.1b9_01.tar.gz
      1.1b/ruby-1.1b9_02.tar.gz
      1.1b/ruby-1.1b9_03.tar.gz
      1.1b/ruby-1.1b9_04.tar.gz
      1.1b/ruby-1.1b9_05.tar.gz
      1.1b/ruby-1.1b9_06.tar.gz
      1.1b/ruby-1.1b9_07.tar.gz
      1.1b/ruby-1.1b9_08.tar.gz
      1.1b/ruby-1.1b9_09.tar.gz
      1.1b/ruby-1.1b9_10.tar.gz
      1.1b/ruby-1.1b9_11.tar.gz
      1.1b/ruby-1.1b9_12.tar.gz
      1.1b/ruby-1.1b9_13.tar.gz
      1.1b/ruby-1.1b9_14.tar.gz
      1.1b/ruby-1.1b9_15.tar.gz
      1.1b/ruby-1.1b9_16.tar.gz
      1.1b/ruby-1.1b9_17.tar.gz
      1.1b/ruby-1.1b9_18.tar.gz
      1.1b/ruby-1.1b9_19.tar.gz
      1.1b/ruby-1.1b9_20.tar.gz
      1.1b/ruby-1.1b9_21.tar.gz
      1.1b/ruby-1.1b9_22.tar.gz
      1.1b/ruby-1.1b9_23.tar.gz
      1.1b/ruby-1.1b9_24.tar.gz
      1.1b/ruby-1.1b9_25.tar.gz
      1.1b/ruby-1.1b9_26.tar.gz
      1.1b/ruby-1.1b9_27.tar.gz
      1.1b/ruby-1.1b9_28.tar.gz
      1.1b/ruby-1.1b9_29.tar.gz
      1.1b/ruby-1.1b9_30.tar.gz
      1.1b/ruby-1.1b9_31.tar.gz
      1.1b/ruby-1.1b9_32.tar.gz
    ],
    %w[
      1.1c/ruby-1.1c0.tar.gz
      1.1c/ruby-1.1c1.tar.gz
      1.1c/ruby-1.1c2.tar.gz
      1.1c/ruby-1.1c3.tar.gz
      1.1c/ruby-1.1c4.tar.gz
      1.1c/ruby-1.1c5.tar.gz
      1.1c/ruby-1.1c6.tar.gz
      1.1c/ruby-1.1c7.tar.gz
      1.1c/ruby-1.1c8.tar.gz
      1.1c/ruby-1.1c9.tar.gz
    ],
    %w[
      1.1d/ruby-1.1d0.tar.gz
      1.1d/ruby-1.1d1.tar.gz
    ],
    %w[
      1.2/ruby-1.2.tar.gz
      1.2/ruby-1.2.1.tar.gz
      1.2/ruby-1.2.2.tar.gz
      1.2/ruby-1.2.3.tar.gz
      1.2/ruby-1.2.4.tar.gz
      1.2/ruby-1.2.5.tar.gz
      1.2/ruby-1.2.6.tar.gz
    ],
    %w[
      1.3/ruby-1.3.tar.gz
      1.3/ruby-1.3.1-990215.tar.gz
      1.3/ruby-1.3.1-990224.tar.gz
      1.3/ruby-1.3.1-990225.tar.gz
      1.3/ruby-1.3.1-990311.tar.gz
      1.3/ruby-1.3.1-990315.tar.gz
      1.3/ruby-1.3.1-990324.tar.gz
      1.3/ruby-1.3.2-990402.tar.gz
      1.3/ruby-1.3.2-990405.tar.gz
      1.3/ruby-1.3.2-990408.tar.gz
      1.3/ruby-1.3.2-990413.tar.gz
      1.3/ruby-1.3.3-990430.tar.gz
      1.3/ruby-1.3.3-990507.tar.gz
      1.3/ruby-1.3.3-990513.tar.gz
      1.3/ruby-1.3.3-990518.tar.gz
      1.3/ruby-1.3.4-990531.tar.gz
      1.3/ruby-1.3.4-990611.tar.gz
      1.3/ruby-1.3.4-990624.tar.gz
      1.3/ruby-1.3.4-990625.tar.gz
      1.3/ruby-1.3.5.tar.gz
      1.3/ruby-1.3.6.tar.gz
      1.3/ruby-1.3.7.tar.gz
    ],
    %w[
      1.4/ruby-1.4.0.tar.gz
      1.4/ruby-1.4.1.tar.gz
      1.4/ruby-1.4.2.tar.gz
      1.4/ruby-1.4.3.tar.gz
      1.4/ruby-1.4.4.tar.gz
      1.4/ruby-1.4.5.tar.gz
      1.4/ruby-1.4.6.tar.gz
    ],
    %w[
      1.6/ruby-1.6.0.tar.gz
      1.6/ruby-1.6.1.tar.gz
      1.6/ruby-1.6.2.tar.gz
      1.6/ruby-1.6.3.tar.gz
      1.6/ruby-1.6.4.tar.gz
      1.6/ruby-1.6.5.tar.gz
      1.6/ruby-1.6.6.tar.gz
      1.6/ruby-1.6.7.tar.gz
      1.6/ruby-1.6.8.tar.gz
    ],
    %w[
      1.8/ruby-1.8.0.tar.gz
      1.8/ruby-1.8.1.tar.gz
      1.8/ruby-1.8.2.tar.gz
      1.8/ruby-1.8.3.tar.gz
      1.8/ruby-1.8.4.tar.gz
    ],
    %w[
      1.8/ruby-1.8.5.tar.gz
      1.8/ruby-1.8.5-p2.tar.gz
      1.8/ruby-1.8.5-p12.tar.gz
      1.8/ruby-1.8.5-p11.tar.gz
      1.8/ruby-1.8.5-p11-repack.tar.gz
      1.8/ruby-1.8.5-p35.tar.gz
      1.8/ruby-1.8.6-p36.tar.bz2
      1.8/ruby-1.8.5-p52.tar.bz2
      1.8/ruby-1.8.5-p113.tar.bz2
      1.8/ruby-1.8.5-p114.tar.bz2
      1.8/ruby-1.8.5-p115.tar.bz2
      1.8/ruby-1.8.5-p231.tar.bz2
    ],
    %w[
      1.8/ruby-1.8.6.tar.bz2
      1.8/ruby-1.8.6-p110.tar.bz2
      1.8/ruby-1.8.6-p111.tar.bz2
      1.8/ruby-1.8.6-p114.tar.bz2
      1.8/ruby-1.8.6-p230.tar.bz2
      1.8/ruby-1.8.6-p286.tar.bz2
      1.8/ruby-1.8.6-p287.tar.bz2
      1.8/ruby-1.8.6-p368.tar.bz2
      1.8/ruby-1.8.6-p369.tar.bz2
      1.8/ruby-1.8.6-p383.tar.bz2
      1.8/ruby-1.8.6-p388.tar.bz2
      1.8/ruby-1.8.6-p398.tar.bz2
      1.8/ruby-1.8.6-p399.tar.bz2
      1.8/ruby-1.8.6-p420.tar.bz2
    ],
    %w[
      1.8/ruby-1.8.7-preview1.tar.bz2
      1.8/ruby-1.8.7-preview2.tar.bz2
      1.8/ruby-1.8.7-preview3.tar.bz2
      1.8/ruby-1.8.7-preview4.tar.bz2
      1.8/ruby-1.8.7.tar.bz2
      1.8/ruby-1.8.7-p17.tar.bz2
      1.8/ruby-1.8.7-p22.tar.bz2
      1.8/ruby-1.8.7-p71.tar.bz2
      1.8/ruby-1.8.7-p72.tar.bz2
      1.8/ruby-1.8.7-p160.tar.bz2
      1.8/ruby-1.8.7-p173.tar.bz2
      1.8/ruby-1.8.7-p174.tar.bz2
      1.8/ruby-1.8.7-p248.tar.bz2
      1.8/ruby-1.8.7-p249.tar.bz2
      1.8/ruby-1.8.7-p299.tar.bz2
      1.8/ruby-1.8.7-p301.tar.bz2
      1.8/ruby-1.8.7-p302.tar.bz2
      1.8/ruby-1.8.7-p330.tar.bz2
      1.8/ruby-1.8.7-p334.tar.bz2
      1.8/ruby-1.8.7-p352.tar.bz2
      1.8/ruby-1.8.7-p357.tar.bz2
      1.8/ruby-1.8.7-p358.tar.bz2
      1.8/ruby-1.8.7-p370.tar.bz2
      1.8/ruby-1.8.7-p371.tar.bz2
      1.8/ruby-1.8.7-p373.tar.bz2
      1.8/ruby-1.8.7-p374.tar.bz2
    ],
    %w[
      1.9/ruby-1.9.0-0.tar.bz2
      1.9/ruby-1.9.0-1.tar.bz2
      1.9/ruby-1.9.0-2.tar.bz2
      1.9/ruby-1.9.0-3.tar.bz2
      1.9/ruby-1.9.0-4.tar.bz2
      1.9/ruby-1.9.0-5.tar.bz2
    ],
    %w[
      1.9/ruby-1.9.1-preview1.tar.bz2
      1.9/ruby-1.9.1-preview2.tar.bz2
      1.9/ruby-1.9.1-rc1.tar.bz2
      1.9/ruby-1.9.1-rc2.tar.bz2
      1.9/ruby-1.9.1-p0.tar.bz2
      1.9/ruby-1.9.1-p129.tar.bz2
      1.9/ruby-1.9.1-p243.tar.bz2
      1.9/ruby-1.9.1-p376.tar.bz2
      1.9/ruby-1.9.1-p378.tar.bz2
      1.9/ruby-1.9.1-p429.tar.bz2
      1.9/ruby-1.9.1-p430.tar.bz2
      1.9/ruby-1.9.1-p431.tar.bz2
    ],
    %w[
      1.9/ruby-1.9.2-preview1.tar.bz2
      1.9/ruby-1.9.2-preview3.tar.bz2
      1.9/ruby-1.9.2-rc1.tar.bz2
      1.9/ruby-1.9.2-rc2.tar.bz2
      1.9/ruby-1.9.2-p0.tar.bz2
      1.9/ruby-1.9.2-p136.tar.bz2
      1.9/ruby-1.9.2-p180.tar.bz2
      1.9/ruby-1.9.2-p290.tar.bz2
      1.9/ruby-1.9.2-p318.tar.bz2
      1.9/ruby-1.9.2-p320.tar.bz2
      1.9/ruby-1.9.2-p330.tar.bz2
    ],
    %w[
      1.9/ruby-1.9.3-preview1.tar.bz2
      1.9/ruby-1.9.3-rc1.tar.bz2
      1.9/ruby-1.9.3-p0.tar.bz2
      1.9/ruby-1.9.3-p105.tar.bz2
      1.9/ruby-1.9.3-p125.tar.bz2
      1.9/ruby-1.9.3-p194.tar.bz2
      1.9/ruby-1.9.3-p286.tar.bz2
      1.9/ruby-1.9.3-p327.tar.bz2
      1.9/ruby-1.9.3-p362.tar.bz2
      1.9/ruby-1.9.3-p374.tar.bz2
      1.9/ruby-1.9.3-p385.tar.bz2
      1.9/ruby-1.9.3-p392.tar.bz2
      1.9/ruby-1.9.3-p426.tar.bz2
      1.9/ruby-1.9.3-p429.tar.bz2
      1.9/ruby-1.9.3-p448.tar.bz2
      1.9/ruby-1.9.3-p484.tar.bz2
      1.9/ruby-1.9.3-p545.tar.bz2
      1.9/ruby-1.9.3-p547.tar.bz2
    ],
    %w[
      2.0/ruby-2.0.0-preview1.tar.bz2
      2.0/ruby-2.0.0-preview2.tar.bz2
      2.0/ruby-2.0.0-rc1.tar.bz2
      2.0/ruby-2.0.0-rc2.tar.bz2
      2.0/ruby-2.0.0-p0.tar.bz2
      2.0/ruby-2.0.0-p195.tar.bz2
      2.0/ruby-2.0.0-p247.tar.bz2
      2.0/ruby-2.0.0-p353.tar.bz2
      2.0/ruby-2.0.0-p451.tar.bz2
      2.0/ruby-2.0.0-p481.tar.bz2
    ],
    %w[
      2.1/ruby-2.1.0-preview1.tar.bz2
      2.1/ruby-2.1.0-preview2.tar.bz2
      2.1/ruby-2.1.0-rc1.tar.bz2
      2.1/ruby-2.1.0.tar.bz2
      2.1/ruby-2.1.1.tar.bz2
      2.1/ruby-2.1.2.tar.bz2
    ]
  ]

  TABLE = []

  TARBALLS.each_with_index {|ary, i|
    ary.each_with_index {|relpath, j|
      dir, fn = File.split(relpath)
      uri = URI_BASE + relpath
      version = fn.dup
      prefix = suffix = ''
      prefix = $& if version.sub!(/\Aruby-/, '')
      suffix = $& if version.sub!(/\.tar\.(gz|bz2)\z/, '')
      TABLE << {
        :i => i,
        :j => j,
        :uri => uri,
        :relpath => relpath,
        :dir => dir,
        :fn => fn,
        :prefix => prefix,
        :version => version,
        :suffix => suffix,
      }
    }
  }

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
    if ary.empty?
      # Assume recent GNU tar which recognize compression automatically.
      system "tar", "xf", filename, :chdir => dirname
      ary = Dir.glob("#{dirname}/*/ruby.c")
    end
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

  def run_command(tag, command, prefixdir)
    FileUtils.mkpath "#{prefixdir}/log"
    log_fn = "#{prefixdir}/log/#{tag}.txt"
    status_fn = "#{prefixdir}/log/#{tag}.status"
    puts tag
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
    puts "fail #{tag}" if !status.success?
    status.success?
  end

  def patch(srcdir, name)
    prefix = File.realpath(dirname)
    patch = File.realpath("patch/#{name}.diff")
    command = ["patch", :in => patch, :chdir => "#{dirname}/#{srcdir}"]
    return false if !run_command("patch-#{name}", command, prefix)
  end

  def apply_workaround(srcdir)
    if global_version_lt('1.9.3-p0')
      FileUtils.rmtree "#{dirname}/#{srcdir}/ext/openssl"
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
    patch srcdir, "parse-midrule-type-1.3.4-990531" if version_eq('1.3.4-990531')
    patch srcdir, "parse-midrule-type-1.3.1-990224" if local_version_between('1.3.1-990224', '1.3.1-990225')
    patch srcdir, "parse-midrule-type-1.2.2" if version_eq('1.2.2')
    if global_version_lt('1.8.0')
      :build_ruby32
    else
      :build_ruby
    end
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
    puts "build #{srcdir}"

    gcc = which('gcc')
    raise "gcc not found." if !gcc

    FileUtils.mkpath "#{prefix}/bin"
    File.open("#{prefix}/bin/gcc", "w") {|f|
      f.puts "#!/bin/sh"
      f.puts "#{gcc} -m32 \"$@\""
    }
    File.chmod(0755, "#{prefix}/bin/gcc")

    setup = [{'CFLAGS'=>'-g -O0',
              'PATH' => "#{prefix}/bin:#{ENV['PATH']}"},
             'setarch', 'i686']

    command = [*setup, "./configure", "--prefix=#{prefix}", :chdir => "#{dirname}/#{srcdir}"]
    if !run_command("configure", command, prefix)
      raise "configure fail"
    end

    command = [*setup, "make", :chdir => "#{dirname}/#{srcdir}"]
    if !run_command("make", command, prefix)
      raise "make fail"
    end

    command = [*setup, "make", "install", :chdir => "#{dirname}/#{srcdir}"]
    if !run_command("install", command, prefix)
      raise "install fail"
    end
  end

  def build_ruby(srcdir)
    prefix = File.realpath(dirname)
    puts "build #{srcdir}"

    command = ["./configure", "--prefix=#{prefix}", :chdir => "#{dirname}/#{srcdir}"]
    if !run_command("configure", command, prefix)
      raise "configure fail"
    end

    command = ["make", :chdir => "#{dirname}/#{srcdir}"]
    if !run_command("make", command, prefix)
      raise "make fail"
    end

    command = ["make", "install", :chdir => "#{dirname}/#{srcdir}"]
    if !run_command("install", command, prefix)
      raise "install fail"
    end
  end

end

task :default do
  puts "\"rake all\" will install #{RubySource::TABLE.length} ruby"
  puts "\"rake list\" shows versions"
end

task :list do
  puts RubySource::TABLE.map {|h| h[:version] }
end

task :all => RubySource::TABLE.map {|h| h[:version] }.reverse

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

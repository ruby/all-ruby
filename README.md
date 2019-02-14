# all-ruby

This software is a script to install historic Ruby versions since ruby-0.49.
Also, all-ruby script runs all ruby binaries with same arguments.

## Platform

This software is developed on Debian GNU/Linux 9 (stretch) amd64.

However Ruby doesn't support 64 bit platform until ruby 1.8.0.
So, the older ruby needs 32 bit development tools which can be
installed as follows.

    % sudo dpkg --add-architecture i386
    % sudo apt update
    % sudo apt-get build-dep ruby2.3
    % sudo apt install rake gcc-multilib \
        zlib1g:i386 libncurses5:i386 libgdbm3:i386 libssl1.0.2:i386 \
        libreadline7:i386 libffi6:i386

## Usage

This software provides Rakefile and "rake all" downloads and builds
historic ruby versions.

    % git clone https://github.com/akr/all-ruby.git
    % cd all-ruby
    % rake setup_build
    % rake all  # this takes long time

Note that `rake setup_build` is same as
`mkdir ../build-all-ruby; ln -s ../build-all-ruby build`.
build-all-ruby directory is required to avoid that
`ruby -v` emits `last_commit=` line.

all-ruby script runs all ruby binaries.

    % ./all-ruby -e 'p RUBY_VERSION'
    ruby-0.49             -e:1: syntax error
                      #<Process::Status: pid 18425 exit 1>
    ...
    ruby-0.51             -e:1: undefined method `p' for "main"(Object)
                      #<Process::Status: pid 18427 exit 1>
    ...
    ruby-0.69             -e:1: Uninitialized constant RUBY_VERSION
                      #<Process::Status: pid 18433 exit 1>
    ...
    ruby-1.3.4-990531     /tmp/rbLIcgCm:1: uninitialized constant RUBY_VERSION (NameError)
                      #<Process::Status: pid 18958 exit 1>
    ruby-1.3.4-990611     "1.3.4"
    ...
    ruby-2.6.1            "2.6.1"

## Documentation

rake without arguments shows the help message for the Rakefile.

    % rake
    "rake all" will install 338 ruby
    "rake list" shows versions
    "rake sync" updates versions

all-ruby without arguments shows help message for all-ruby script.

    % ./all-ruby
    usage: all-ruby RUBY-ARGS
    environment variables:
      ALL_RUBY_SINCE=ruby-1.4               run only versions since specified one
      ALL_RUBY_BINS='ruby-2.4.4 ruby-2.5.1' run only versions specfied
      ALL_RUBY_ADDBINS=./ruby               run specified commands additionaly
      ALL_RUBY_SHOW_DUP=yes                 don't suppress duplicated output

## Links

- https://github.com/akr/all-ruby

## Author

Tanaka Akira
akr@fsij.org

## License

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions and the following
    disclaimer in the documentation and/or other materials provided
    with the distribution.
 3. The name of the author may not be used to endorse or promote
    products derived from this software without specific prior
    written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(3-clause BSD license)

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

    % rake all  # this takes long time

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
    ruby-2.6.0-preview1   "2.6.0"

## Documentation

rake without arguments shows the help message for the Rakefile.

    % rake
    "rake all" will install 327 ruby
    "rake list" shows versions
    "rake sync" updates versions

all-ruby without arguments shows help message for all-ruby script.

    % ./all-ruby
    usage: all-ruby RUBY-ARGS
    environments:
      ALL_RUBY_SINCE=ruby-1.4
      ALL_RUBY_SHOW_DUP=yes
      ALL_RUBY_BINS='ruby-2.1.10 ruby-2.2.10 ruby-2.3.7 ruby-2.4.4 ruby-2.5.1'
      ALL_RUBY_ADDBINS=./ruby       space-separated binaries to be run

## Links

- https://github.com/akr/all-ruby

## Author

Tanaka Akira
akr@fsij.org

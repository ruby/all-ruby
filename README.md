# all-ruby

This software is a script to install histric Ruby versions since ruby-0.49.
Also, all-ruby script runs all ruby binaries with same arguments.

## Usage

Install 32bit compilation tools to install ruby before version 1.8.0.
The older ruby doesn't support 64bit environment.
Debian GNU/Linux 8 (jessie) (amd64) supports these tools as follows.

    % sudo dpkg --add-architecture i386
    % sudo aptitude install gcc-multilib \
        zlib1g:i386 libncurses5:i386 libgdbm3:i386 libssl1.0.0:i386 \
        libreadline6:i386 libffi5:i386

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
    ruby-2.4.0-preview1   "2.4.0"

## Documentation

rake without arguments shows the help message for the Rakefile.

    % rake
    "rake all" will install 284 ruby
    "rake list" shows versions
    "rake sync" updates versions.json

all-ruby without arguments shows help message for all-ruby script.

    % ./all-ruby
    usage: all-ruby RUBY-ARGS
    environments:
      ALL_RUBY_SINCE=ruby-1.4 all-ruby RUBY-ARGS

## Links

- https://github.com/akr/all-ruby

## Author

Tanaka Akira
akr@fsij.org

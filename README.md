# rubylang/all-ruby

Historic Ruby versions since ruby-0.49, all built and packaged into a single image. The bundled `all-ruby` script runs every Ruby binary with the same arguments so you can compare behavior across versions.

* Docker Hub: https://hub.docker.com/r/rubylang/all-ruby
* GitHub Container Registry: https://github.com/ruby/all-ruby/pkgs/container/all-ruby
* Source: https://github.com/ruby/all-ruby

## Quick start

Pull the latest image and list the bundled Ruby versions:

```
docker pull rubylang/all-ruby:latest
docker run --rm rubylang/all-ruby ./all-ruby -v
```

The `latest` tag contains every supported Ruby version in one image.

## What is this?

This image bundles historic Ruby releases starting from ruby-0.49 and provides an `all-ruby` script that invokes each `ruby` binary in turn with the same arguments. It is useful for checking when a feature was introduced, when behavior changed, or how a snippet runs across the entire Ruby history.

## Usage

Run the same script across every bundled Ruby:

```
% docker run --rm rubylang/all-ruby ./all-ruby -e 'p RUBY_VERSION'
ruby-0.49             -e:1: syntax error
                  exit 1
ruby-0.50             -e:1: syntax error
                  exit 1
ruby-0.51             -e:1: undefined method `p' for "main"(Object)
                  exit 1
...
ruby-1.3.4-990611     "1.3.4"
...
ruby-2.7.0-preview1   "2.7.0"
```

Limit the range with `ALL_RUBY_SINCE`, or add your own Ruby into the comparison with `ALL_RUBY_ADDBINS`:

```
% docker run --rm -e 'ALL_RUBY_SINCE=ruby-2.0' \
    rubylang/all-ruby ./all-ruby -e 'p 0.class'
ruby-2.0.0-p0         Fixnum
...
ruby-2.3.8            Fixnum
ruby-2.4.0-preview1   Integer
...
```

`./all-ruby` without arguments prints the supported environment variables:

```
% ./all-ruby
usage: all-ruby RUBY-ARGS
environment variables:
  ALL_RUBY_SINCE=ruby-1.4               run only versions since specified one
  ALL_RUBY_BINS='ruby-2.4.4 ruby-2.5.1' run only versions specfied
  ALL_RUBY_ADDBINS=./ruby               run specified commands additionaly
  ALL_RUBY_SHOW_DUP=yes                 don't suppress duplicated output
```

## Images

- **`rubylang/all-ruby:latest`** — every supported Ruby version in a single image. Also mirrored to `ghcr.io/ruby/all-ruby:latest`.

## Contributing

The Dockerfile and build scripts live in the [ruby/all-ruby](https://github.com/ruby/all-ruby) repository.

### Building Ruby binaries locally

The Rakefile downloads and builds the historic Ruby versions:

```
% git clone https://github.com/ruby/all-ruby.git
% cd all-ruby
% rake setup_build
% rake all  # this takes long time
```

`rake setup_build` is equivalent to `mkdir ../build-all-ruby; ln -s ../build-all-ruby build`. The `build-all-ruby` directory is required to prevent `ruby -v` from emitting a `last_commit=` line.

`rake` without arguments prints the available tasks:

```
% rake
"rake all" will install 384 ruby
"rake list" shows versions
"rake sync" updates versions
```

### Platform requirements

The build is developed on Debian GNU/Linux 10 (buster) amd64. Ruby did not support 64-bit platforms until ruby 1.8.0, so older Rubies require 32-bit development tools:

```
% sudo dpkg --add-architecture i386
% sudo apt update
% sudo apt-get build-dep ruby2.5
% sudo apt install rake gcc-multilib \
    zlib1g:i386 libncurses5:i386 libgdbm6:i386 libssl1.1:i386 \
    libreadline7:i386 libffi6:i386
```

For Debian GNU/Linux 9 (stretch):

```
% sudo apt-get build-dep ruby2.3
% sudo apt install rake gcc-multilib \
    zlib1g:i386 libncurses5:i386 libgdbm3:i386 libssl1.0.2:i386 \
    libreadline7:i386 libffi6:i386
```

### Building the Docker image locally

```
% docker build ./ -t my-all-ruby
```

The build uses all available CPUs in parallel. Restrict it with the `j` build argument (or `--cpuset-cpus`):

```
% docker build ./ --build-arg j=1 -t my-all-ruby
```

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

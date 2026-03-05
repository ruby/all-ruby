ARG os=debian
ARG version=bookworm
ARG variant=-slim
ARG mirror=http://deb.debian.org/debian
ARG system_ruby=ruby3.1

# rake -j interpret non-numeric argument as number of CPUs plus 3.
ARG j=numcpu_plus_alpha

# =============================================================================
# Base build environment: Debian Buster (for legacy Ruby versions)
# =============================================================================
FROM debian:buster-slim AS builder-buster
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://archive.debian.org/debian/ buster main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security/ buster/updates main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update -o Acquire::Check-Valid-Until=false

RUN dpkg --add-architecture i386 \
  && echo "deb-src http://archive.debian.org/debian/ buster main" > /etc/apt/sources.list.d/deb-src.list \
  && echo 'Dpkg::Use-Pty "0";\nquiet "2";\nAPT::Install-Recommends "0";' > /etc/apt/apt.conf.d/99autopilot \
  && echo 'Acquire::HTTP::No-Cache "True";' > /etc/apt/apt.conf.d/99no-cache \
  && apt-get update -o Acquire::Check-Valid-Until=false \
  && apt-get install \
      build-essential \
      gcc-multilib \
      bison \
      rdfind \
      file \
      libruby2.5:amd64 \
      libruby2.5:i386 \
  && apt-get build-dep ruby2.5 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /all-ruby

COPY Rakefile /all-ruby/
COPY lib/ruby_version.rb /all-ruby/lib/
COPY patch /all-ruby/patch/
RUN rake setup_build

# =============================================================================
# Ruby 0.x-2.0.0 on Debian Buster
# =============================================================================
FROM builder-buster AS ruby-0.x-2.0
ARG j=numcpu_plus_alpha

COPY versions/0.* versions/1.0* versions/1.1* versions/1.8.0* versions/1.8.1* versions/1.8.2* versions/1.8.3* versions/1.8.4* versions/1.8.5* versions/2.0.0* /all-ruby/versions/
RUN rake -j ${j} all-0 all-1.0 all-1.1a all-1.1b all-1.1c all-1.1d all-1.8 all-1.8.5
RUN rake -j ${j} all-2.0.0

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Base build environment: Debian Bullseye (for Ruby 1.2-3.0)
# =============================================================================
FROM debian:bullseye-slim AS builder-bullseye
ENV DEBIAN_FRONTEND=noninteractive
ARG mirror

RUN dpkg --add-architecture i386 \
  && echo "deb-src ${mirror} bullseye main" > /etc/apt/sources.list.d/deb-src.list \
  && echo 'Dpkg::Use-Pty "0";\nquiet "2";\nAPT::Install-Recommends "0";' > /etc/apt/apt.conf.d/99autopilot \
  && echo 'Acquire::HTTP::No-Cache "True";' > /etc/apt/apt.conf.d/99no-cache \
  && apt-get update \
  && apt-get install \
      build-essential \
      gcc-multilib \
      bison \
      rdfind \
      file \
      libruby2.7:amd64 \
      libruby2.7:i386 \
  && apt-get build-dep ruby2.7 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /all-ruby

COPY Rakefile /all-ruby/
COPY lib/ruby_version.rb /all-ruby/lib/
COPY patch /all-ruby/patch/
RUN rake setup_build

# =============================================================================
# Ruby 1.2-1.8.7
# =============================================================================
FROM builder-bullseye AS ruby-1.2-1.8.7
ARG j=numcpu_plus_alpha

COPY versions/1.2* versions/1.3* versions/1.4* versions/1.6* versions/1.8.6* versions/1.8.7* /all-ruby/versions/
RUN rake -j ${j} all-1.2 all-1.3 all-1.4 all-1.6 all-1.8.6 all-1.8.7

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Ruby 1.9.x
# =============================================================================
FROM builder-bullseye AS ruby-1.9
ARG j=numcpu_plus_alpha

COPY versions/1.9* /all-ruby/versions/
RUN rake -j ${j} all-1.9.0 all-1.9.1 all-1.9.2
RUN rake -j ${j} all-1.9.3

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Ruby 2.1
# =============================================================================
FROM builder-bullseye AS ruby-2.1
ARG j=numcpu_plus_alpha

COPY versions/2.1* /all-ruby/versions/
RUN rake -j ${j} all-2.1

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Ruby 2.2
# =============================================================================
FROM builder-bullseye AS ruby-2.2
ARG j=numcpu_plus_alpha

COPY versions/2.2* /all-ruby/versions/
RUN rake -j ${j} all-2.2

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Ruby 2.3
# =============================================================================
FROM builder-bullseye AS ruby-2.3
ARG j=numcpu_plus_alpha

COPY versions/2.3* /all-ruby/versions/
RUN rake -j ${j} all-2.3

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Ruby 2.4
# =============================================================================
FROM builder-bullseye AS ruby-2.4
ARG j=numcpu_plus_alpha

COPY versions/2.4* /all-ruby/versions/
RUN rake -j ${j} all-2.4

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Ruby 2.5
# =============================================================================
FROM builder-bullseye AS ruby-2.5
ARG j=numcpu_plus_alpha

COPY versions/2.5* /all-ruby/versions/
RUN rake -j ${j} all-2.5

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Ruby 2.6
# =============================================================================
FROM builder-bullseye AS ruby-2.6
ARG j=numcpu_plus_alpha

COPY versions/2.6* /all-ruby/versions/
RUN rake -j ${j} all-2.6

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Ruby 2.7
# =============================================================================
FROM builder-bullseye AS ruby-2.7
ARG j=numcpu_plus_alpha

COPY versions/2.7* /all-ruby/versions/
RUN rake -j ${j} all-2.7

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Ruby 3.0
# =============================================================================
FROM builder-bullseye AS ruby-3.0
ARG j=numcpu_plus_alpha

COPY versions/3.0* /all-ruby/versions/
RUN rake -j ${j} all-3.0

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Base build environment: Debian Bookworm (for Ruby 3.1+)
# =============================================================================
FROM ${os}:${version}${variant} AS builder-bookworm
ENV DEBIAN_FRONTEND=noninteractive
ARG mirror
ARG version
ARG system_ruby

RUN dpkg --add-architecture i386 \
  && echo "deb-src ${mirror} ${version} main" > /etc/apt/sources.list.d/deb-src.list \
  && echo 'Dpkg::Use-Pty "0";\nquiet "2";\nAPT::Install-Recommends "0";' > /etc/apt/apt.conf.d/99autopilot \
  && echo 'Acquire::HTTP::No-Cache "True";' > /etc/apt/apt.conf.d/99no-cache \
  && apt-get update \
  && apt-get install \
      build-essential \
      gcc-multilib \
      bison \
      rdfind \
      file \
      lib${system_ruby}:amd64 \
      lib${system_ruby}:i386 \
  && apt-get build-dep ${system_ruby} \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /all-ruby

COPY Rakefile /all-ruby/
COPY lib/ruby_version.rb /all-ruby/lib/
COPY patch /all-ruby/patch/
RUN rake setup_build

# =============================================================================
# Ruby 3.1
# =============================================================================
FROM builder-bookworm AS ruby-3.1
ARG j=numcpu_plus_alpha

COPY versions/3.1* /all-ruby/versions/
RUN rake -j ${j} all-3.1

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Ruby 3.2
# =============================================================================
FROM builder-bookworm AS ruby-3.2
ARG j=numcpu_plus_alpha

COPY versions/3.2* /all-ruby/versions/
RUN rake -j ${j} all-3.2

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Ruby 3.3
# =============================================================================
FROM builder-bookworm AS ruby-3.3
ARG j=numcpu_plus_alpha

COPY versions/3.3* /all-ruby/versions/
RUN rake -j ${j} all-3.3

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Ruby 3.4
# =============================================================================
FROM builder-bookworm AS ruby-3.4
ARG j=numcpu_plus_alpha

COPY versions/3.4* /all-ruby/versions/
RUN rake -j ${j} all-3.4

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

# =============================================================================
# Ruby 3.5-4.0
# =============================================================================
FROM builder-bookworm AS ruby-3.5-4.0
ARG j=numcpu_plus_alpha

COPY versions/3.5* versions/4.0* /all-ruby/versions/
RUN rake -j ${j} 3.5.0-preview1 all-4.0

RUN rm -rf Rakefile versions/ patch/ DIST build/*/log build/*/ruby*/ \
      build/*/man build/*/share/man build/*/share/doc build/*/share/ri && \
    rm -f build/*/lib/libruby-static.a build/*/bin/gcc build/*/bin/cc
RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip

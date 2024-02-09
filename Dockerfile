ARG os=debian
ARG version=bookworm
ARG variant=-slim
ARG mirror=http://deb.debian.org/debian
ARG system_ruby=ruby3.1

# Build for 0.*, 1.0*, 1.1*, 1.8.0-4, 1.8.5 and 2.0.0
FROM debian:buster-slim
ENV DEBIAN_FRONTEND=noninteractive
ARG mirror

RUN dpkg --add-architecture i386 \
  && echo "deb-src ${mirror} buster main" > /etc/apt/sources.list.d/deb-src.list \
  && echo 'Dpkg::Use-Pty "0";\nquiet "2";\nAPT::Install-Recommends "0";' > /etc/apt/apt.conf.d/99autopilot \
  && echo 'Acquire::HTTP::No-Cache "True";' > /etc/apt/apt.conf.d/99no-cache \
  && apt-get update \
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

# rake -j interpret non-numeric argument as number of CPUs plus 3.
ARG j=numcpu_plus_alpha

COPY versions/0.* versions/1.* versions/2.0.0* /all-ruby/versions/
RUN rake -j ${j} all-0 all-1.0 all-1.1a all-1.1b all-1.1c all-1.1d all-1.8 all-1.8.5
RUN rake -j ${j} all-2.0.0

RUN rm -rf Rakefile versions/ patch/
RUN rm -rf DIST build/*/log build/*/ruby*/
RUN rm -rf build/*/man build/*/share/man build/*/share/doc build/*/share/ri
RUN rm -f build/*/lib/libruby-static.a
RUN rm -f build/*/bin/gcc build/*/bin/cc

# Build for 1.2*, 1.3*, 1.4*, 1.6*, 1.8.6, 1.8.7, 1.9 and 2.1-3.0
FROM debian:bullseye-slim
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
  && apt-get build-dep libruby2.7 \
  && rm -rf /var/lib/apt/lists/*

COPY --from=0 /build-all-ruby/ /build-all-ruby
COPY --from=0 /all-ruby/ /all-ruby

WORKDIR /all-ruby

COPY Rakefile /all-ruby/
COPY lib/ruby_version.rb /all-ruby/lib/
COPY patch /all-ruby/patch/
RUN rake setup_build

# rake -j interpret non-numeric argument as number of CPUs plus 3.
ARG j=numcpu_plus_alpha

COPY versions/1.* versions/2.1* versions/2.2* versions/2.3* versions/2.4* versions/2.5* versions/2.6* versions/2.7* versions/3.0* /all-ruby/versions/
RUN rake -j ${j} all-1.2 all-1.3 all-1.4 all-1.6 all-1.8.6 all-1.8.7
RUN rake -j ${j} all-1.9.0 all-1.9.1 all-1.9.2
RUN rake -j ${j} all-1.9.3
RUN rake -j ${j} all-2.1
RUN rake -j ${j} all-2.2
RUN rake -j ${j} all-2.3
RUN rake -j ${j} all-2.4
RUN rake -j ${j} all-2.5
RUN rake -j ${j} all-2.6
RUN rake -j ${j} all-2.7
RUN rake -j ${j} all-3.0

RUN rm -rf Rakefile versions/ patch/
RUN rm -rf DIST build/*/log build/*/ruby*/
RUN rm -rf build/*/man build/*/share/man build/*/share/doc build/*/share/ri
RUN rm -f build/*/lib/libruby-static.a
RUN rm -f build/*/bin/gcc build/*/bin/cc

FROM ${os}:${version}${variant}
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

COPY --from=1 /build-all-ruby/ /build-all-ruby
COPY --from=1 /all-ruby/ /all-ruby

WORKDIR /all-ruby

COPY Rakefile /all-ruby/
COPY lib/ruby_version.rb /all-ruby/lib/
COPY patch /all-ruby/patch/
RUN rake setup_build

# rake -j interpret non-numeric argument as number of CPUs plus 3.
ARG j=numcpu_plus_alpha

COPY versions/3.1* versions/3.2* versions/3.3* /all-ruby/versions/
RUN rake -j ${j} all-3.1
RUN rake -j ${j} all-3.2
RUN rake -j ${j} all-3.3

COPY lib/* /all-ruby/lib/
COPY all-ruby /all-ruby/

RUN rm -rf Rakefile versions/ patch/
RUN rm -rf DIST build/*/log build/*/ruby*/
RUN rm -rf build/*/man build/*/share/man build/*/share/doc build/*/share/ri
RUN rm -f build/*/lib/libruby-static.a
RUN rm -f build/*/bin/gcc build/*/bin/cc

RUN find /build-all-ruby -type f \( -name ruby -o -name '*.so' \) -exec sh -c 'file $1 | grep -q "not stripped"' - '{}' \; -print0 | xargs -0 strip
RUN rdfind -makehardlinks true -makeresultsfile false /build-all-ruby

FROM ${os}:${version}${variant}
ENV DEBIAN_FRONTEND=noninteractive
ARG mirror
ARG version
ARG system_ruby

# gcc is required for mjit of ruby 2.6

RUN dpkg --add-architecture i386 \
  && echo "deb-src ${mirror} ${version} main" > /etc/apt/sources.list.d/deb-src.list \
  && echo 'Dpkg::Use-Pty "0";\nquiet "2";\nAPT::Install-Recommends "0";' > /etc/apt/apt.conf.d/99autopilot \
  && echo 'Acquire::HTTP::No-Cache "True";' > /etc/apt/apt.conf.d/99no-cache \
  && apt-get update \
  && apt-get install \
      libc6:i386 \
      libffi8:i386 \
      libgcc1:i386 \
      libgdbm6:i386 \
      libncurses5:i386 \
      libreadline8:i386 \
      libssl3:i386 \
      zlib1g:i386 \
      libffi8:amd64 \
      libgdbm6:amd64 \
      libncurses5:amd64 \
      libreadline8:amd64 \
      libssl3:amd64 \
      zlib1g:amd64 \
      gcc \
      ${system_ruby} \
  && rm -rf /var/lib/apt/lists/*

COPY --from=2 /build-all-ruby/ /build-all-ruby
COPY --from=2 /all-ruby/ /all-ruby

# for Ruby 0.x and 1.1x
COPY --from=2 /lib/i386-linux-gnu/libcrypt.so.1.1.0 /lib/i386-linux-gnu/libcrypt.so.1.1.0
RUN cd /lib/i386-linux-gnu && ln -s libcrypt.so.1.1.0 libcrypt.so.1

WORKDIR /all-ruby

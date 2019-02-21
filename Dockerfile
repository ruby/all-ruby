ARG os=debian
ARG version=stretch
ARG variant=-slim
ARG mirror=http://deb.debian.org/debian
ARG system_ruby=ruby2.3

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
      lib${system_ruby}:amd64 \
      lib${system_ruby}:i386 \
  && apt-get build-dep ${system_ruby} \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /all-ruby

COPY Rakefile /all-ruby/
COPY lib/ruby_version.rb /all-ruby/lib/
COPY patch /all-ruby/patch/
RUN rake setup_build

ARG j=1
ARG rm_files="DIST build/*/log build/*/ruby*/ build/*/man build/*/share/man build/*/share/doc build/*/share/ri"
ARG rdfind_opts="-makehardlinks true -makeresultsfile false"

COPY versions/0.* versions/1.* versions/2.0.0* versions/2.1* versions/2.2* /all-ruby/versions/
RUN rake -j ${j} all-0     && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/0*
RUN rake -j ${j} all-1.0   && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.0*
RUN rake -j ${j} all-1.1a  && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.1a*
RUN rake -j ${j} all-1.1b  && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.1b*
RUN rake -j ${j} all-1.1c  && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.1c*
RUN rake -j ${j} all-1.1d  && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.1d*
RUN rake -j ${j} all-1.2   && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.2*
RUN rake -j ${j} all-1.3   && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.3*
RUN rake -j ${j} all-1.4   && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.4*
RUN rake -j ${j} all-1.6   && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.6*
RUN rake -j ${j} all-1.8   && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.8*
RUN rake -j ${j} all-1.8.5 && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.8.5*
RUN rake -j ${j} all-1.8.6 && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.8.6*
RUN rake -j ${j} all-1.8.7 && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.8.7*
RUN rake -j ${j} all-1.9.0 && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.9.0*
RUN rake -j ${j} all-1.9.1 && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.9.1*
RUN rake -j ${j} all-1.9.2 && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.9.2*
RUN rake -j ${j} all-1.9.3 && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/1.9.3*
RUN rake -j ${j} all-2.0.0 && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/2.0.0*
RUN rake -j ${j} all-2.1   && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/2.1*
RUN rake -j ${j} all-2.2   && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/2.2*

COPY versions/2.3* /all-ruby/versions/
RUN rake -j ${j} all-2.3   && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/2.3*

COPY versions/2.4* /all-ruby/versions/
RUN rake -j ${j} all-2.4   && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/2.4*

COPY versions/2.5* /all-ruby/versions/
RUN rake -j ${j} all-2.5   && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/2.5*

COPY versions/2.6* /all-ruby/versions/
RUN rake -j ${j} all-2.6   && rm -rf ${rm_files} && rdfind ${rdfind_opts} build/2.6*

RUN rm -rf Rakefile versions/ patch/
COPY lib/* /all-ruby/lib/
COPY all-ruby /all-ruby/

FROM ${os}:${version}${variant}
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
      libffi6:i386 \
      libgcc1:i386 \
      libgdbm3:i386 \
      libncurses5:i386 \
      libreadline7:i386 \
      libssl1.0.2:i386 \
      zlib1g:i386 \
      libffi6:amd64 \
      libgdbm3:amd64 \
      libncurses5:amd64 \
      libreadline7:amd64 \
      libssl1.0.2:amd64 \
      zlib1g:amd64 \
      gcc \
      ${system_ruby} \
  && rm -rf /var/lib/apt/lists/*

COPY --from=0 /all-ruby/ /all-ruby
COPY --from=0 /build-all-ruby/ /build-all-ruby

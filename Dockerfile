ARG os=debian
ARG version=stretch
ARG variant=-slim
ARG mirror=http://deb.debian.org/debian
ARG system_ruby=ruby2.3

FROM ${os}:${version}${variant}

ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386
ARG mirror
ARG version
RUN echo "deb-src ${mirror} ${version} main" > /etc/apt/sources.list.d/deb-src.list
RUN echo $'Dpkg::Use-Pty "0";\nquiet "2";\nAPT::Install-Recommends "0";' > /etc/apt/apt.conf.d/99autopilot
RUN echo 'Acquire::HTTP::No-Cache "True";' > /etc/apt/apt.conf.d/99no-cache
RUN apt-get update
RUN apt-get install build-essential
RUN apt-get install gcc-multilib
RUN apt-get install bison
RUN apt-get install rdfind
ARG system_ruby
RUN apt-get install lib${system_ruby}:amd64
RUN apt-get install lib${system_ruby}:i386
RUN apt-get build-dep ${system_ruby}
RUN apt-get upgrade    \
 && apt-get autoremove \
 && apt-get clean

ADD Rakefile all-ruby versions.json /all-ruby/
ADD patch /all-ruby/patch/
WORKDIR /all-ruby

ARG j=1
RUN rake -j ${j} all-0     && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 0*
RUN rake -j ${j} all-1.0   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.0*
RUN rake -j ${j} all-1.1a  && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.1a*
RUN rake -j ${j} all-1.1b  && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.1b*
RUN rake -j ${j} all-1.1c  && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.1c*
RUN rake -j ${j} all-1.1d  && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.1d*
RUN rake -j ${j} all-1.2   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.2*
RUN rake -j ${j} all-1.3   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.3*
RUN rake -j ${j} all-1.4   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.4*
RUN rake -j ${j} all-1.6   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.6*
RUN rake -j ${j} all-1.8   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.8*
RUN rake -j ${j} all-1.8.5 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.8.5*
RUN rake -j ${j} all-1.8.6 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.8.6*
RUN rake -j ${j} all-1.8.7 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.8.7*
RUN rake -j ${j} all-1.9.0 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.9.0*
RUN rake -j ${j} all-1.9.1 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.9.1*
RUN rake -j ${j} all-1.9.2 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.9.2*
RUN rake -j ${j} all-2.0.0 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 2.0.0*
RUN rake -j ${j} all-2.1   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 2.1*
RUN rake -j ${j} all-2.2   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 2.2*
RUN rake -j ${j} all-2.3   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 2.3*
RUN rake -j ${j} all-2.4   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 2.4*
RUN rake -j ${j} all-2.5.0 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 2.5.0*

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

ADD Rakefile all-ruby /all-ruby/
ADD patch /all-ruby/patch/
WORKDIR /all-ruby

ARG j=1

ADD versions/0.49.json versions/0.50.json versions/0.54.json versions/0.55.json versions/0.60.json versions/0.65.json versions/0.69.json versions/0.73.json versions/0.76.json versions/0.95.json versions/0.99.4-961224.json versions/1.0-961225.json versions/1.1a0.json versions/1.1a4.json versions/1.1b0.json versions/1.1b3.json versions/1.1b7.json versions/1.1b9_05.json versions/1.1b9_07.json versions/1.1b9_09.json versions/1.1b9_19.json versions/1.1d0.json versions/1.3.2-990413.json versions/1.3.3-990430.json versions/1.8.0.json versions/1.8.5.json versions/1.8.6-p230.json versions/1.8.7-p22.json versions/1.9.1-p0.json versions/1.9.1-preview2.json versions/1.9.3-p426.json versions/2.4.0.json /all-ruby/versions/
ADD versions/0.* /all-ruby/versions/
RUN rake -j ${j} all-0     && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 0*
ADD versions/1.0* /all-ruby/versions/
RUN rake -j ${j} all-1.0   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.0*
ADD versions/1.1* /all-ruby/versions/
RUN rake -j ${j} all-1.1a  && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.1a*
RUN rake -j ${j} all-1.1b  && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.1b*
RUN rake -j ${j} all-1.1c  && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.1c*
RUN rake -j ${j} all-1.1d  && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.1d*
ADD versions/1.2* /all-ruby/versions/
RUN rake -j ${j} all-1.2   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.2*
ADD versions/1.3* /all-ruby/versions/
RUN rake -j ${j} all-1.3   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.3*
ADD versions/1.4* /all-ruby/versions/
RUN rake -j ${j} all-1.4   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.4*
ADD versions/1.6* /all-ruby/versions/
RUN rake -j ${j} all-1.6   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.6*
ADD versions/1.8.0* versions/1.8.1* versions/1.8.2* versions/1.8.3* versions/1.8.4* /all-ruby/versions/
RUN rake -j ${j} all-1.8   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.8*
ADD versions/1.8.5* /all-ruby/versions/
RUN rake -j ${j} all-1.8.5 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.8.5*
ADD versions/1.8.6* /all-ruby/versions/
RUN rake -j ${j} all-1.8.6 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.8.6*
ADD versions/1.8.7* /all-ruby/versions/
RUN rake -j ${j} all-1.8.7 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.8.7*
ADD versions/1.9.0* /all-ruby/versions/
RUN rake -j ${j} all-1.9.0 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.9.0*
ADD versions/1.9.1* /all-ruby/versions/
RUN rake -j ${j} all-1.9.1 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.9.1*
ADD versions/1.9.2* /all-ruby/versions/
RUN rake -j ${j} all-1.9.2 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.9.2*
ADD versions/1.9.3* /all-ruby/versions/
RUN rake -j ${j} all-1.9.3 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 1.9.3*
ADD versions/2.0.0* /all-ruby/versions/
RUN rake -j ${j} all-2.0.0 && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 2.0.0*
ADD versions/2.1* /all-ruby/versions/
RUN rake -j ${j} all-2.1   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 2.1*
ADD versions/2.2* /all-ruby/versions/
RUN rake -j ${j} all-2.2   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 2.2*
ADD versions/2.3* /all-ruby/versions/
RUN rake -j ${j} all-2.3   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 2.3*
ADD versions/2.4* /all-ruby/versions/
RUN rake -j ${j} all-2.4   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 2.4*
ADD versions/2.5* /all-ruby/versions/
RUN rake -j ${j} all-2.5   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 2.5*
ADD versions/2.6* /all-ruby/versions/
RUN rake -j ${j} 2.6.0-preview1 2.6.0-preview2   && rm -rf DIST */log */ruby*/ && rdfind -makehardlinks true 2.6*

ARG os=debian
ARG version=stretch
ARG variant=-slim
FROM ${os}:${version}${variant}

ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386
ARG mirror=http://deb.debian.org/debian
ARG version
RUN echo "deb-src ${mirror} ${version} main" > /etc/apt/sources.list.d/deb-src.list
RUN echo $'Dpkg::Use-Pty "0";\nquiet "2";\nAPT::Install-Recommends "0";' > /etc/apt/apt.conf.d/99autopilot
RUN echo 'Acquire::HTTP::No-Cache "True";' > /etc/apt/apt.conf.d/99no-cache
RUN apt-get update
ARG system_ruby=ruby2.3
RUN apt-get install build-essential \
                    gcc-multilib \
                    bison \
                    rdfind \
                    lib${system_ruby}:amd64 \
                    lib${system_ruby}:i386 
RUN apt-get build-dep ${system_ruby} 
RUN apt-get upgrade    \
 && apt-get autoremove \
 && apt-get clean

WORKDIR /all-ruby

ADD Rakefile /all-ruby/
ADD lib/ruby_version.rb /all-ruby/lib/
ADD patch /all-ruby/patch/
RUN rake setup_build

ARG j=1

ADD versions/0.* versions/1.* versions/2.0.0* versions/2.1* versions/2.2* /all-ruby/versions/
RUN rake -j ${j} all-0     && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/0*
RUN rake -j ${j} all-1.0   && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.0*
RUN rake -j ${j} all-1.1a  && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.1a*
RUN rake -j ${j} all-1.1b  && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.1b*
RUN rake -j ${j} all-1.1c  && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.1c*
RUN rake -j ${j} all-1.1d  && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.1d*
RUN rake -j ${j} all-1.2   && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.2*
RUN rake -j ${j} all-1.3   && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.3*
RUN rake -j ${j} all-1.4   && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.4*
RUN rake -j ${j} all-1.6   && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.6*
RUN rake -j ${j} all-1.8   && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.8*
RUN rake -j ${j} all-1.8.5 && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.8.5*
RUN rake -j ${j} all-1.8.6 && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.8.6*
RUN rake -j ${j} all-1.8.7 && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.8.7*
RUN rake -j ${j} all-1.9.0 && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.9.0*
RUN rake -j ${j} all-1.9.1 && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.9.1*
RUN rake -j ${j} all-1.9.2 && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.9.2*
RUN rake -j ${j} all-1.9.3 && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/1.9.3*
RUN rake -j ${j} all-2.0.0 && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/2.0.0*
RUN rake -j ${j} all-2.1   && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/2.1*
RUN rake -j ${j} all-2.2   && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/2.2*

ADD versions/2.3* /all-ruby/versions/
RUN rake -j ${j} all-2.3   && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/2.3*

ADD versions/2.4* /all-ruby/versions/
RUN rake -j ${j} all-2.4   && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/2.4*

ADD versions/2.5* /all-ruby/versions/
RUN rake -j ${j} all-2.5   && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/2.5*

ADD versions/2.6* /all-ruby/versions/
RUN rake -j ${j} all-2.6   && rm -rf DIST build/*/log build/*/ruby*/ && rdfind -makehardlinks true build/2.6*

RUN rm -rf result.txt Rakefile versions/ patch/
ADD lib/* /all-ruby/lib/
ADD all-ruby /all-ruby/

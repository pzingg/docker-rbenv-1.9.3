############################################################
# Dockerfile to build a base for any Ruby application
# Installs rbenv and ruby 1.9.3 to /opt/rbenv
# Base image is Amazon Linux AMI
############################################################
FROM vettl/amazon-linux

MAINTAINER peter.zingg@gmail.com

ENV HOME /root

# Git and ruby dependencies
RUN yum install -y git gcc gcc-c++ patch \
  readline readline-devel zlib zlib-deve bzip2 \
  libyaml-devel libffi-devel openssl-devel iconv-devel \ 
  curl tar make autoconf automake libtool bison \
  sqlite-devel postgresql94-devel mysql-community-server 

RUN git clone https://github.com/sstephenson/rbenv.git /opt/rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /opt/rbenv/plugins/ruby-build
ENV PATH /opt/rbenv/bin:/opt/rbenv/shims:$PATH
ENV RBENV_ROOT /opt/rbenv
RUN /opt/rbenv/plugins/ruby-build/install.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

# We don't want documentation to be generated for ruby
ENV CONFIGURE_OPTS --disable-install-doc
RUN echo 'gem: --no-rdoc --no-ri' >> /etc/gemrc
RUN rbenv install 1.9.3
RUN rbenv global 1.9.3
RUN rbenv rehash

# Install bundler gem
RUN gem install bundler -N
RUN rbenv rehash

# Add Gemfile ruby version
RUN git clone https://github.com/aripollak/rbenv-bundler-ruby-version.git /opt/rbenv/plugins/rbenv-bundler-ruby-version

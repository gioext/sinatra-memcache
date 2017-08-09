FROM ruby:2.4.1
MAINTAINER dgvigil@gmail.com

ENV APP_HOME /opt/sinatra_memcache
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile $APP_HOME/Gemfile
ADD Gemfile.lock $APP_HOME/Gemfile.lock
RUN bundle install
ADD . $APP_HOME




FROM ruby:2.1.2

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/
COPY Gemfile.lock /app/
RUN bundle install --system
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists

COPY . /app/

EXPOSE 3000
CMD /app/bin/docker_start

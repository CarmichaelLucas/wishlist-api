FROM ruby:2.6.6

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client
WORKDIR /myapp
RUN chmod 777 /myapp
COPY ./Gemfile /myapp/Gemfile
COPY ./Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
EXPOSE 4567
EXPOSE 1080
EXPOSE 1025
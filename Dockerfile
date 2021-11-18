FROM ruby:3.0.2-alpine

RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
      postgresql-dev \
      tzdata

RUN gem install rails:6.1.4 bundler

RUN ls

WORKDIR /app

COPY Gemfile Gemfile.lock Rakefile ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

COPY . ./

EXPOSE 3000

ENTRYPOINT ["./docker/entrypoints/docker-entrypoint.sh"]

FROM elixir:latest

COPY . /byu_course_map

WORKDIR /byu_course_map

RUN apt-get -y update
RUN apt-get -y install inotify-tools

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.clean --all
RUN mix deps.get
RUN mix --version
RUN mix deps.compile

CMD mix phx.server
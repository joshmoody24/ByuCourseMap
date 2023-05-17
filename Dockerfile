FROM elixir:alpine

COPY . /byu_course_map

WORKDIR /byu_course_map

RUN apk update
RUN apk add inotify-tools
RUN apk add git

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.clean --all
RUN mix deps.get
RUN mix --version

CMD mix phx.server
FROM rust:1.75-slim AS build

WORKDIR /usr/src/app

COPY ./gotham /user/src/app

RUN cargo build --release && strip target/release/server

FROM debian:stable-slim

COPY --from=build /usr/src/app/target/release/server /usr/src/app/target/release/server

CMD sh

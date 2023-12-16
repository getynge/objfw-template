FROM getynge/objfw-build:1.0.5 as build
WORKDIR /opt/program-build
COPY . .
RUN make

FROM scratch AS output
ARG name
COPY --from=build /usr/local/lib /
COPY --from=build /opt/program-build/${name} /${name}

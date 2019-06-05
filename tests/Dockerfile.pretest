ARG IMAGE
FROM $IMAGE
MAINTAINER Romain Beauxis <toots@rastageeks.org>

USER root

RUN rm -rf /home/opam/opam-cross-windows/packages

ADD packages/ /home/opam/opam-cross-windows/packages

ADD repo /home/opam/opam-cross-windows/repo

RUN chown -R opam /home/opam/opam-cross-windows

USER opam

RUN opam update windows

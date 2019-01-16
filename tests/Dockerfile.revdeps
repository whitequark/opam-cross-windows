ARG IMAGE
FROM $IMAGE
MAINTAINER Romain Beauxis <toots@rastageeks.org>

ARG OPAM_PKG

USER opam

RUN opam list --short --recursive --external --vars os-distribution=mxe --depends-on=$OPAM_PKG > /home/opam/mxe-revdeps

USER root

RUN cd /usr/src/mxe/ && cat /home/opam/mxe-revdeps | xargs make

USER opam

RUN eval $(opam config env) && opam list --rec --short --sort --depends-on=$OPAM_PKG | while read i; do opam install --verbose "$i"; done

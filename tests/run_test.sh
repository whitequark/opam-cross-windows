#!/bin/sh

TEST_PWD=$(cd `dirname $0` && pwd)
PACKAGE=$1

printf "Building ${PACKAGE}.. "

DOCKER_CMD="docker build -f ${TEST_PWD}/Dockerfile.windows-x64-test --no-cache --build-arg \"OPAM_PKG=${PACKAGE}\" . 2>/dev/null"

if [ -f "${TEST_PWD}/../packages/${PACKAGE}/.tested" ]; then
  printf "\033[0;32m[ok]\033[0m✅\n"
else
  if [ -n "${VERBOSE}" ]; then
    echo ""
    /bin/sh -c "${DOCKER_CMD}"
  else
    /bin/sh -c "${DOCKER_CMD} >/dev/null"
  fi

  if [ "$?" -ne "0" ]; then
    printf "\033[0;31m[failed]\033[0m🚫\n"
    exit 128
  else
    printf "\033[0;32m[ok]\033[0m✅\n"
    touch "${TEST_PWD}/../packages/${PACKAGE}/.tested"
  fi
fi

if [ -n "${REVDEPS}" ]; then
  printf "Building ${PACKAGE} reverse dependencies.. "

  DOCKER_CMD="docker build -f ${TEST_PWD}/Dockerfile.windows-x64-revdeps --no-cache --build-arg \"OPAM_PKG=${PACKAGE}\" . 2>/dev/null"

  if [ -n "${VERBOSE}" ]; then
    echo ""
    /bin/sh -c "${DOCKER_CMD}"
  else
    /bin/sh -c "${DOCKER_CMD} >/dev/null"
  fi

  if [ "$?" -ne "0" ]; then
    printf "\033[0;31m[failed]\033[0mð"
    exit 128
  else
    printf "\033[0;32m[ok]\033[0mân"
  fi
fi

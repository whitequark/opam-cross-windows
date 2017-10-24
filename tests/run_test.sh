#!/bin/sh

TEST_PWD=$(cd `dirname $0` && pwd)
PACKAGE=$1

SKIPPED="conf-gcc-windows64.1 zmq-windows.4.0-7"

printf "Building ${PACKAGE}.. "

echo "${SKIPPED}" | grep "${PACKAGE}" >/dev/null 2>&1

if [ "$?" -eq "0" ]; then
  printf "\033[1;33m[skipped]\033[0m⚠️\n"
  exit 0
fi

RET=$(docker build -f ${TEST_PWD}/Dockerfile.windows-x86-test --no-cache --build-arg "OPAM_PKG=${PACKAGE}" ${TEST_PWD} 2>/dev/null)

if [ "$?" -ne "0" ]; then
  if [ -n "${VERBOSE}" ]; then
    echo "\n\nError while building ${PACKAGE}:\n-=-=-=-=-=-=-=-=-=\n"
    echo "${RET}" | tail -n 50
    echo "\n-=-=-=-=-=-=-=-=-=\n"
  else
    printf "\033[0;31m[failed]\033[0m🚫\n"
  fi

  exit 128
else
  printf "\033[0;32m[ok]\033[0m✅\n"
fi

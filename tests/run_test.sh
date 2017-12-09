#!/bin/sh

TEST_PWD=$(cd `dirname $0` && pwd)
PACKAGE=$1

printf "Building ${PACKAGE}.. "

DOCKER_CMD="docker build -f ${TEST_PWD}/Dockerfile.windows-x86-test --no-cache --build-arg \"OPAM_PKG=${PACKAGE}\" . 2>/dev/null"

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
fi

if [ -n "${REVDEPS}" ]; then
  printf "Building ${PACKAGE} reverse dependencies.. "

  DOCKER_CMD="docker build -f ${TEST_PWD}/Dockerfile.windows-x86-revdeps --no-cache --build-arg \"OPAM_PKG=${PACKAGE}\" . 2>/dev/null"

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

echo "${NO_REVDEPS}" | grep "${PACKAGE}" >/dev/null 2>&1

if [ "$?" -eq "0" ]; then
  printf "\033[0;32m[ok]\033[0m✅✅ \n"
  exit 0
fi

RET=$(docker build -f ${TEST_PWD}/Dockerfile.windows-x86-revdeps --no-cache --build-arg "SKIPPED=${SKIPPED}" --build-arg "OPAM_PKG=${PACKAGE}" ${TEST_PWD} 2>/dev/null)

if [ "$?" -ne "0" ]; then
  if [ -n "${VERBOSE}" ]; then
    echo "\n\nError while building ${PACKAGE} revdeps:\n-=-=-=-=-=-=-=-=-=\n"
    echo "${RET}" | tail -n 50
    echo "\n-=-=-=-=-=-=-=-=-=\n"
  else
    printf "\033[0;31m[failed]\033[0m🚫 \n"
  fi

  exit 128
fi

printf "\033[0;32m[ok]\033[0m✅ \n"

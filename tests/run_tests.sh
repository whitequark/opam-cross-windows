#!/bin/sh

TEST_PWD=$(cd `dirname $0` && pwd)
BASE_PWD=$(cd ${TEST_PWD}/.. && pwd)

if [ -n "${BUILD_BASE}" ]; then
  printf "Building base image.. "

  DOCKER_CMD="docker build -f ${TEST_PWD}/Dockerfile.windows-x86-base -t ocamlcross/windows-x86-base:latest ${BASE_PWD}"

  if [ -n "${VERBOSE}" ]; then
    echo ""
    /bin/sh -c "${DOCKER_CMD}"
  else
    /bin/sh -c "${DOCKER_CMD} >/dev/null"
  fi

  if [ "$?" -ne "0" ]; then
    printf "\033[0;31m[failed]\033[0m🚫 \n"
  else
    printf "\033[0;32m[ok]\033[0m✅ \n"
  fi
fi

SKIPPED="ao-windows.0.2.1 ocaml-windows64.4.04.0 conf-gcc-windows64.1 lwt-zmq-windows.2.0.1 zmq-windows.4.0-7"

printf "Building pretest image.."
DOCKER_CMD="docker build -f ${TEST_PWD}/Dockerfile.windows-x86-pretest -t ocamlcross/windows-x86-pretest:latest --build-arg \"OPAM_SKIPPED=${SKIPPED}\" ${BASE_PWD}"

if [ -n "${VERBOSE}" ]; then
  echo ""
  /bin/sh -c "${DOCKER_CMD}"
else
  /bin/sh -c "${DOCKER_CMD} >/dev/null"
fi

if [ "$?" -ne "0" ]; then
  printf "\033[0;31m[failed]\033[0m🚫🚫 \n"
else
  printf "\033[0;32m[ok]\033[0m✅  \n"
fi

build_package() {
  PACKAGE=$1

  echo "${SKIPPED}" | grep "${PACKAGE}" >/dev/null 2>&1

  if [ "$?" -eq "0" ]; then
    printf "\033[1;33m[skipped]\033[0m⚠️\n"
  else
    ${TEST_PWD}/run_test.sh "${PACKAGE}"

    if [ "$?" -ne "0" ]; then
      exit 128
    fi
  fi
}

PACKAGES=$(cd ${BASE_PWD}/packages && find . -maxdepth 1 -mindepth 1 -type d | cut -d '/' -f 2 | sort -u)

echo ""
git remote set-branches origin '*'
git fetch origin master
echo ""

echo "${PACKAGES}" | while read PACKAGE; do
  if [ -n "${WORLD}" ]; then
    build_package "${PACKAGE}"
  else
    RET=$(cd "${BASE_PWD}/packages/${PACKAGE}" && git diff --name-only HEAD origin/master .)

    if [ -n "${RET}" ]; then
      build_package "${PACKAGE}"
    fi
  fi
done


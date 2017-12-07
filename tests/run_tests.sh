#!/bin/sh

TEST_PWD=$(cd `dirname $0` && pwd)
BASE_PWD=$(cd ${TEST_PWD}/.. && pwd)

if [ -n "${BUILD_BASE}" ]; then
  printf "Building base image.. "
  RET=$(docker build -f ${TEST_PWD}/Dockerfile.windows-x86-base -t ocamlcross/windows-x86-base:latest ${BASE_PWD} 2>/dev/null) 

  if [ "$?" -ne "0" ]; then
    if [ -n "${VERBOSE}" ]; then
      echo "\n\nError while building base image:\n-=-=-=-=-=-=-=-=-=\n"
      echo "${RET}" | tail -n 50
      echo "\n-=-=-=-=-=-=-=-=-=\n"
    else
      printf "\033[0;31m[failed]\033[0m🚫 \n"
    fi
  else
    printf "\033[0;32m[ok]\033[0m✅ \n"
  fi
fi

build_package() {
  PACKAGE=$1

  ${TEST_PWD}/run_test.sh "${PACKAGE}"

  if [ "$?" -ne "0" ]; then
    exit 128
  fi
}

PACKAGES=$(cd ${BASE_PWD}/packages && find . -maxdepth 1 -mindepth 1 -type d | cut -d '/' -f 2 | sort -u)

git remote set-branches origin '*'
git fetch origin master

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


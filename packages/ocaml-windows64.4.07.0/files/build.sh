#!/bin/sh -e

if grep "WITH_SPACETIME=true" config/Makefile >/dev/null 2>/dev/null; then
  echo "#define WITH_SPACETIME" >> config/m.h
fi 

make world opt \
  compilerlibs/ocamlcommon.cmxa compilerlibs/ocamlbytecomp.cmxa \
  compilerlibs/ocamloptcomp.cmxa driver/main.cmx driver/optmain.cmx

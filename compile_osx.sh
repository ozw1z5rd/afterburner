# path to your Osx cross-compiler
CC=clang

GCOM=`git  rev-parse --short HEAD`


$CC -g3 -O0 -DNO_CLOSE -DGCOM="\"g${GCOM}\"" -o afterburner  src_pc/afterburner.c

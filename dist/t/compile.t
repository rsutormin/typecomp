#!/bin/sh

mkdir -p t/script
mkdir -p t/lib
PERL5LIB=blib
blib/script/compile_typespec.pl --scripts t/script --psgi service.psgi t/MyFirstService.spec t/lib


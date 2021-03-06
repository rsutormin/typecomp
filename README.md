KBase Type Compiler
===================

The KBase Type Compiler consumes a type-document and produces a
server and implementation libraries in one language and client
libraries in multiple supported languages.

Usage
-----

This module generates two executables to compile specification
documents into client/server libraries:

    compile_typespec
    compile_dbd_to_typespec

Run these commands with no arguments for usage information.

Development
-----------

**Do not modify** the following files directly, as they are
automatically generated by Parse::Yapp based on the corresponding
yp file in the top level of the repository:

    lib/Bio/KBase/KIDL/erdoc.pm
    lib/Bio/KBase/KIDL/typedoc.pm

To recompile the grammars, run "make".

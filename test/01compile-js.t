use strict;
use warnings;

use Test::Simple tests => 3;
use File::Temp qw/tempfile tempdir/;

my $FIXTURES = './test/fixtures';
my $SCRIPTS  = './scripts';
my $LIBS     = './lib';

my $script = "$SCRIPTS/compile_typespec.pl";
my $jsname = "simple";
my $outdir = tempdir("/tmp/typecomp-test-XXXX");
my $jslibrary = "$outdir/$jsname.js";

system "perl", "-I$LIBS", $script, "--js", $jsname, "$FIXTURES/simple-service.spec", $outdir;
ok($? == 0, "compile_typesec ran correctly");
ok(-e $jslibrary, "JS library was generated");

my $jswrap =<<EOJS;
var fs = require("fs");
var vm = require("vm");
var jQuery = {
    Deferred: function () {
        return { promise: function () {} };
    },
    ajax: function () {}
};
var window = { console: console };
var sandbox = { \$: jQuery, jQuery: jQuery, console: console, window: window }; 
var data = fs.readFileSync("$jslibrary", "utf8");
vm.runInNewContext(data, sandbox);
var client = new sandbox.SimpleService("localhost");
console.log("f1");
client.functinator();
console.log("f2");
client.functinator_async();
console.log("f3");
client.functinator_async(); // Warning should only appear once
EOJS

my $nodeout = `node -e '$jswrap'`;
ok($nodeout =~ /^f1\nf2\nDEPRECATION WARNING:.*\nf3$/,
    "_async functions generate a deprecation warning once.");

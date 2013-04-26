use strict;
use warnings;

use Test::Simple tests => 2;
use File::Temp qw/tempfile tempdir/;

my $FIXTURES = './test/fixtures';
my $SCRIPTS  = './scripts';
my $LIBS     = './lib';

my $script = "$SCRIPTS/compile_typespec.pl";
my $jsname = "simple";
my $outdir = tempdir("/tmp/typecomp-test-XXXX");
my $jslibrary = "$outdir/$jsname.js";

system "perl", "-I$LIBS", $script, "--js", $jsname, "$FIXTURES/simple-service.spec", $outdir;
ok($? == 0);

my $jswrap =<<EOJS;
var fs = require("fs");
var vm = require("vm");
var jQuery = {
    Deferred: function () {
        return { promise: function () {} };
    },
    ajax: function () {}
};
var sandbox = { \$: jQuery, jQuery: jQuery, console: console }; 
var data = fs.readFileSync("$jslibrary", "utf8");
vm.runInNewContext(data, sandbox);
var client = new sandbox.SimpleService("localhost");
console.log(client.functinator_async());
EOJS

system "node", "-e", $jswrap;
ok($? == 0);

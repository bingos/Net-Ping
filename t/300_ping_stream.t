BEGIN {
    if ($ENV{PERL_CORE}) {
	unless ($ENV{PERL_TEST_Net_Ping}) {
	    print "1..0 # Skip: network dependent test\n";
	    exit;
	}
	chdir 't' if -d 't';
	@INC = qw(../lib);
    }
}

# Test of stream protocol using loopback interface.
#
# NOTE:
#   The echo service must be enabled on localhost
#   to better test the the stream protocol ping.

use Test;
use Net::Ping;
plan tests => 12;

my $p = new Net::Ping "stream";

# new() worked?
ok !!$p;

# Attempt to connect to the echo port
if ($p -> ping("localhost")) {
  ok 1;
  # Try several pings while it is connected
  for (1..10) {
    ok $p -> ping("localhost");
  }
} else {
  # Echo port is off, skip the tests
  for (2..12) { skip "Local echo port is off", 1; }
  exit;
}

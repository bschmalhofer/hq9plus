=head1 NAME

t/00-sanity.t - tests for HQ9plus

=head1 DESCRIPTION

This just checks that the basic parsing and call to builtin say() works.

=cut

use strict;
use warnings;

use FindBin ();
use lib "$FindBin::Bin/../lib", "$FindBin::Bin/../../../lib";

use Parrot::Test tests => 4;

for my $i ( 1 .. 4 ) {
    language_output_is( 'hq9plus', "say $i;", "$i\n", "say $i" );
}

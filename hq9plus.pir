=head1 TITLE

hq9plus.pir - A HQ9plus compiler.

=head2 Description

This is the entry point for the HQ9plus compiler.

=head2 Functions

=over 4

=item main(args :slurpy)  :main

Start compilation by passing any command line C<args>
to the HQ9plus compiler.

=cut

.sub 'main' :main
    .param pmc args

    load_language 'hq9plus'

    $P0 = compreg 'HQ9plus'
    $P1 = $P0.'command_line'(args)
.end

=back

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:


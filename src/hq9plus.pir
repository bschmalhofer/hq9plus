=head1 TITLE

hq9plus.pir - A HQ9plus compiler.

=head2 Description

This is the base file for the HQ9plus compiler.

This file includes the parsing and grammar rules from
the src/ directory, loads the relevant PGE libraries,
and registers the compiler under the name 'HQ9plus'.

=head2 Functions

=over 4

=item onload()

Creates the HQ9plus compiler using a C<PCT::HLLCompiler>
object.

=cut

.HLL 'hq9plus'
#.loadlib 'hq9plus_group'

.namespace []

.sub '' :anon :load
    load_bytecode 'HLL.pbc'

    .local pmc hllns, parrotns, imports
    hllns = get_hll_namespace
    parrotns = get_root_namespace ['parrot']
    imports = split ' ', 'PAST PCT HLL Regex Hash'
    parrotns.'export_to'(hllns, imports)
.end

.include 'src/gen_grammar.pir'
.include 'src/gen_actions.pir'
.include 'src/gen_compiler.pir'
.include 'src/gen_runtime.pir'

#.include 'src/builtins/hello.pir'
#.include 'src/builtins/nintynine_bottles_of_beer.pir'
#.include 'src/builtins/plus.pir'
#.include 'src/builtins/quine.pir'

=back

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

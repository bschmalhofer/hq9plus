#!/usr/bin/env parrot
# $Id$

=head1 NAME

setup.pir - Python distutils style

=head1 DESCRIPTION

No Configure step, no Makefile generated.

=head1 USAGE

    $ parrot setup.pir build
    $ parrot setup.pir test
    $ sudo parrot setup.pir install

=cut

.sub 'main' :main
    .param pmc args
    $S0 = shift args
    load_bytecode 'distutils.pbc'

    .const 'Sub' testclean = 'testclean'
    register_step_after('test', testclean)
    register_step_after('clean', testclean)

    $P0 = new 'Hash'
    $P0['name'] = 'HQ9plus'
    $P0['abstract'] = 'HQ9plus is a non turing-complete joke language'
    $P0['authority'] = 'http://github.com/bschmalhofer'
    $P0['description'] = 'HQ9plus is a non turing-complete joke language. See http://www.esolangs.org/wiki/HQ9_Plus for details.'
    $P0['license_type'] = 'Artistic License 2.0'
    $P0['license_uri'] = 'http://www.perlfoundation.org/artistic_license_2_0'
    $P0['copyright_holder'] = 'Parrot Foundation'
    $P0['checkout_uri'] = 'git://github.com/bschmalhofer/hq9plus.git'
    $P0['browser_uri'] = 'http://github.com/bschmalhofer/hq9plus'
    $P0['project_uri'] = 'http://github.com/bschmalhofer/hq9plus'

    # build
    $P1 = new 'Hash'
    $P1['src/gen_grammar.pir'] = 'src/parser/grammar.pg'
    $P0['pir_pge'] = $P1

    $P2 = new 'Hash'
    $P2['src/gen_actions.pir'] = 'src/parser/actions.pm'
    $P0['pir-nqp-rx'] = $P2

    $P3 = new 'Hash'
    $P4 = split "\n", <<'SOURCES'
src/hq9plus.pir
src/gen_grammar.pir
src/gen_actions.pir
src/builtins/hello.pir
src/builtins/nintynine_bottles_of_beer.pir
src/builtins/plus.pir
src/builtins/quine.pir
SOURCES
    $S0 = pop $P4
    $P3['hq9plus/hq9plus.pbc'] = $P4
    $P3['hq9plus.pbc'] = 'hq9plus.pir'
    $P0['pbc_pir'] = $P3

    $P5 = new 'Hash'
    $P5['parrot-hq9plus'] = 'hq9plus.pbc'
#    $P0['installable_pbc'] = $P5

    # test
    $S0 = get_libdir()
    $S0 = 'perl -I ' . $S0
    $S0 .= '/tools/lib'
    $P0['prove_exec'] = $S0

    # install
    $P0['inst_lang'] = 'hq9plus/hq9plus.pbc'

    .tailcall setup(args :flat, $P0 :flat :named)
.end

.sub 'testclean' :anon
    .param pmc kv :slurpy :named
    system("perl -MExtUtils::Command -e rm_f t/*.HQ9plus t/*.out")
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:


class HQ9plus::Compiler is HLL::Compiler;

INIT {
    HQ9plus::Compiler.language('HQ9plus');
    HQ9plus::Compiler.parsegrammar(HQ9plus::Grammar);
    HQ9plus::Compiler.parseactions(HQ9plus::Actions);
}

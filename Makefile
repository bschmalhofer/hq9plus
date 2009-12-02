## arguments we want to run parrot with
PARROT_ARGS   :=

## configuration settings
VERSION       := /parrot/1.8.0-devel
BIN_DIR       := /usr/local/bin
LIB_DIR       := /usr/local/lib$(VERSION)
DOC_DIR       := /usr/local/share/doc$(VERSION)
MANDIR        := /usr/local/man$(VERSION)

# Set up extensions
O             := .o

# Various paths
PERL6GRAMMAR  := $(LIB_DIR)/library/PGE/Perl6Grammar.pbc
NQP           := $(LIB_DIR)/languages/nqp/nqp.pbc
PCT           := $(LIB_DIR)/library/PCT.pbc

## Setup some commands
PERL          := /usr/bin/perl
CAT           := $(PERL) -MExtUtils::Command -e cat
CHMOD         := $(PERL) -MExtUtils::Command -e ExtUtils::Command::chmod
CP            := $(PERL) -MExtUtils::Command -e cp
MKPATH        := $(PERL) -MExtUtils::Command -e mkpath
RM_F          := $(PERL) -MExtUtils::Command -e rm_f
RM_RF         := $(PERL) -MExtUtils::Command -e rm_rf
POD2MAN       := pod2man
PARROT        := $(BIN_DIR)/parrot
PBC_TO_EXE    := $(BIN_DIR)/pbc_to_exe

SOURCES := \
  src/hq9plus.pir \
  src/gen_grammar.pir \
  src/gen_actions.pir \
  src/builtins/hello.pir \
  src/builtins/nintynine_bottles_of_beer.pir \
  src/builtins/plus.pir \
  src/builtins/quine.pir

DOCS := README

BUILD_CLEANUPS := \
  hq9plus.pbc \
  "src/gen_*.pir" \
  "*.c" \
  "*$(O)" \
  installable_hq9plus

TEST_CLEANUPS := \
  "t/*.HQ9plus" \
  "t/*.out"

# the default target
build: \
  hq9plus/hq9plus.pbc \
  hq9plus.pbc

all: build installable

hq9plus.pbc: hq9plus.pir
	$(PARROT) $(PARROT_ARGS) -o hq9plus.pbc hq9plus.pir

hq9plus/hq9plus.pbc: $(SOURCES)
	$(PARROT) $(PARROT_ARGS) -o hq9plus/hq9plus.pbc src/hq9plus.pir

src/gen_grammar.pir: $(PERL6GRAMMAR) src/parser/grammar.pg
	$(PARROT) $(PARROT_ARGS) $(PERL6GRAMMAR) \
	    --output=src/gen_grammar.pir \
	    src/parser/grammar.pg

src/gen_actions.pir: $(NQP) src/parser/actions.pm
	$(PARROT) $(PARROT_ARGS) $(NQP) --output=src/gen_actions.pir \
	    --target=pir src/parser/actions.pm


installable: installable_hq9plus

installable_hq9plus: hq9plus.pbc
	$(PBC_TO_EXE) hq9plus.pbc --install

Makefile: Makefile.in
	$(PARROT) Configure.pir

# This is a listing of all targets, that are meant to be called by users
help:
	@echo ""
	@echo "Following targets are available for the user:"
	@echo ""
	@echo "  build:             hq9plus.pbc"
	@echo "                     This is the default."
	@echo "  hq9plus      Self-hosting binary not to be installed."
	@echo "  all:               hq9plus.pbc hq9plus installable"
	@echo "  installable:       Create libs and self-hosting binaries to be installed."
	@echo "  install:           Install the installable targets and docs."
	@echo ""
	@echo "Testing:"
	@echo "  test:              Run the test suite."
	@echo "  test-installable:  Test self-hosting targets."
	@echo "  testclean:         Clean up test results."
	@echo ""
	@echo "Cleaning:"
	@echo "  clean:             Basic cleaning up."
	@echo "  realclean:         Removes also files generated by 'Configure.pl'"
	@echo "  distclean:         Removes also anything built, in theory"
	@echo ""
	@echo "Misc:"
	@echo "  help:              Print this help message."
	@echo ""

test: build
	prove -I $(LIB_DIR)/tools/lib t/*.t

install: installable
	$(CP) installable_hq9plus $(BIN_DIR)/parrot-hq9plus
	$(CHMOD) 0755 $(BIN_DIR)/parrot-hq9plus
	-$(MKPATH) $(LIB_DIR)/languages/hq9plus
	$(CP) hq9plus/hq9plus.pbc $(LIB_DIR)/languages/hq9plus/hq9plus.pbc
	-$(MKPATH) $(MANDIR)/man1
	$(POD2MAN) doc/running.pod > $(MANDIR)/man1/parrot-hq9plus.1
	-$(MKPATH) $(DOC_DIR)/languages/hq9plus
	$(CP) $(DOCS) $(DOC_DIR)/languages/hq9plus

uninstall:
	$(RM_F) $(BIN_DIR)/parrot-hq9plus
	$(RM_RF) $(LIB_DIR)/languages/hq9plus
	$(RM_F) $(MANDIR)/man1/parrot-hq9plus.1
	$(RM_RF) $(DOC_DIR)/languages/hq9plus

win32-inno-installer: installable
	-$(MKPATH) man/man1
	$(POD2MAN) doc/running.pod > man/man1/parrot-hq9plus.1
	-$(MKPATH) man/html
	pod2html --infile doc/running.pod --outfile man/html/parrot-hq9plus.html
	$(CP) installable_hq9plus parrot-hq9plus.exe
	$(PERL) -I$(LIB_DIR)/tools/lib $(LIB_DIR)/tools/dev/mk_inno_language.pl hq9plus
	iscc parrot-hq9plus.iss

testclean:
	$(RM_F) $(TEST_CLEANUPS)

clean:
	$(RM_F) $(TEST_CLEANUPS) $(BUILD_CLEANUPS)

realclean:
	$(RM_F) $(TEST_CLEANUPS) $(BUILD_CLEANUPS) Makefile

distclean: realclean

# Local variables:
#   mode: makefile
# End:
# vim: ft=make:




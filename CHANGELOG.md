# Changelog

## [0.53] - 2024-07-26

### Changed

- m_vcf (vcquery) can be build with libvc (--with-libvc=vc) as an
  alternative to libvformat (--with-libvc-vformat) now.  In auto-mode
  libvc is preferred over libvformat.
- Add scope option to mutt-ldap-query (m_ldap).  Thanks to Ben
  Collerson <benc@benc.cc>
  (https://github.com/RolandRosenfeld/lbdb/pull/9)
- Add testsuite for m_vcf.
- Add support to m_vcf for running testsuite on local built code (via
  $USE_LOCAL_LIB).

## [0.52.1] - 2023-07-29

### Fixed

- Fix version information.

## [0.52] - 2023-07-29

### Changed

- The m_inmail DB is now located by default in
  $XDG_DATA_HOME/lbdb/m_inmail.db.  For backward compatibility an
  already existing $HOME/.lbdb/m_inmail.utf-8 file is used as first
  preference (https://bugs.debian.org/843917)

### Added

- Add $XDG_CONFIG_HOME/lbdb/config as additional ldbdrc file location,
  and $XDG_CONFIG_HOME/lbdb/ldap.rc as additional ldaprc file location
  (Thanks to Michael Tretter <michael.tretter@posteo.net>)
  (https://github.com/RolandRosenfeld/lbdb/pull/5)

### Fixed

- lbdb-fetchaddr: discard stdin at the end to avoid problems with
  tee(1) and command substitution
  (https://github.com/RolandRosenfeld/lbdb/issues/7)

## [0.51.1] - 2022-09-18

### Fixed

- Repair missing 7bit name part in rfc2047 on arm and mips architecture.

## [0.51] - 2022-09-17

### Added

- Add support for running testsuite on local built code (via $USE_LOCAL_LIB).
- Add testsuite for m_inmail/lbdb-fetchaddr.

### Fixed

- Fix example of MUNGE_LIMITDATE in lbdb.rc.
- Ignore case and non alphanumeric chars in SORT_OUTPUT=name.
- Update dotlock code from mutt 2.2.1 (uses snprintf now).
- Update rfc822 code from mutt 2.2.1.
- Fix quoting of grep Regex in m_muttalias.

## [0.50] - 2022-02-25

### Changed

- Split Debian package (hosted on salsa.debian.org) and upstream
  package (hosted on github.com)

## [0.49.1] - 2021-10-09

### Fixed

- Create empty config.rpath to make autoconf 2.71 happy
  (https://bugs.debian.org/995983).

## [0.49] - 2020-11-13

### Changed

- Move mutt_ldap_query from libdir to bindir, since it can be called separately.

### Fixed

- lbdbq: re-add $exec_prefix, which may be used in libdir.
- Forward INMAIL_DB default from m_inmail to lbdb-munge.


## [0.48.1] - 2019-01-07

### Fixed

- Fix wrong quoting in lbdb-fetchaddr (https://bugs.debian.org/918594)

## [0.48] - 2019-01-04

### Added

- Add tests for m_abook.

### Fixed

- m_inmail/lbdb-munge: Use INMAIL_DB if set in config
  (https://bugs.debian.org/916282)

### Changed

- m_muttalias: Fix some shellcheck warnings.
- m_abook: Fix a shellcheck warning.
- lbdbq, lbdb-fetchaddr: Fix some shellcheck warnings.
- Change project homepage URL to https.
- Use literal tab characters in order to make m_abook and m_goobook
  modules work without requiring GNU sed(1).  Thanks to Raf Czlonka.
- Add update-version target to update version in all autotool files.

## [0.47] - 2018-04-02

### Added

- Add a test suite.
  - Add a test for m_muttalias.
- Make the database file for m_inmail/lbdb-fetchaddr configurable.

### Changed

- Add .gitignore based on code by Lucas Hoffmann.
- Replace legacy `...` by $(...) in sh scripts.
- Update copyright notice.
- Add test_perl to check perl syntax.
- Replace undefined $rv by $?.
- Add LBDB_OVERRIDE_METHODS, OVERRIDE_MUTTALIAS_FILES variables for
  testing.
- m_muttalias: rewrite sed regex as ERE, which should be more POSIX
  compatible and should work on non GNU sed, too.
- lbdbq: Remove whitespace from number of matches to become more
  portable.

## [0.46] - 2018-01-14

### Added

- Add new module m_mu (maildir-utils), provided by Timothy Bourke.

## [0.45.2] - 2017-11-12

### Fixed

- Rename configure.in to configure.ac to make autoconf happy.
- lbdb.el: Replace obsolete (as of 23.2) function interactive-p.
- lbdb_bbdb_query.el: Fix emacs warning.

## [0.44] - 2017-09-11

### Fixed

- Fix count in m_inmail munge.
- Stop adding trailing spaces to date in m_inmail.utf-8.
- Remove unwanted trailing spaces from date field in m_imail.utf-8.
  Thanks to Peter P. for reporting this issue.

## [0.43] - 2017-07-01

### Added

- m_khard: New CardDAV module using khard.  Thanks to Colin Watson for
  providing the patch (https://bugs.debian.org/866178).

### Changed

- Rebuild aclocal with version 1.15.
- Update config.guess and config.sub from autotools-dev 20161112.1

## [0.42.1] - 2016-12-11

### Fixed

-  lbdb-munge: fix autoconf libdir path (https://bugs.debian.org/84773).

## [0.42] - 2016-11-07

### Added

- m_gpg, m_pgp[25]: extend allowed real name length from 27 to 47 chars
  (https://bugs.debian.org/825333).
- Add new module m_goobook, which reads addresses from Google contacts
  using goobook package.  Thanks for providing this to François Charlier.
- Allow one to remove outdated or infrequently used entries from m_inmail.
  Thanks to Yaroslav Halchenko for providing a patch
  (https://bugs.debian.org/406232).

### Changed

- Change lbdb-fetchaddr/m_inmail default charset to UTF-8
  (https://bugs.debian.org/600462).
  To avoid problems on upgrading, the database file name was changed
  from $HOME/.lbdb/m_inmail.list to $HOME/.lbdb/m_inmail.utf-8.  If you
  want to keep your old (ISO-8859-15 encoded) database, you can just
  append it to the new file by
   cd $HOME/.lbdb
   iconv -f iso-8859-15 -t utf-8 < m_inmail.list >> m_inmail.utf-8

### Fixed

- Update autotools.
- Merge changes from mutt 1.7.1 dotlock.c.
- Get rid of warn_unused_resuld from dotlock.c.

## [0.41] - 2016-03-05

### Changed

- fetchaddr: change real name length limit from 30 to 70.  Thanks to
  Andrey Skvortsov for providing a patch (https://bugs.debian.org/780532).

### Fixed

- Remove CVS $Id$ tags and the like, which don't work with git.
- Apply several patches by Lucas Hoffmann:
  - m_wanderlust: Fix variable name.
  - m_gnomecard, m_pine: Remove needless backslashes from embedded AWK.
  - lbdbq: Optimize counting lines.
  - lbdbq: Remove unreached break after exit.
- fetchaddr: avoid segfault on empty lines (https://bugs.debian.org/715901).
- vcquery: order N: field: Prefixes GivenName AddName FamilyName Suffix
  (https://bugs.debian.org/578155).
- Remove lbdb.spec on clean target.
- Move LIBICONV linking to the end of the cc call to make cygwin happy.
- Substitute ${prefix} in @sysconfdir@ in mutt_ldap_query.pl.
- Fix more bashisms (Thanks to Thorsten Glaser).
- Update config.guess and config.sub.

## [0.40] - 2016-01-30

### Fixed

- Avoid gpg trustdb check in m_gpg, since this may take a long time
  while lbdb is not responsible.  Thanks to Gregor Zattler for providing
  a patch (https://bugs.debian.org/805235).
- mutt_ldap_query: escape parentheses, since perl 5.22 complains about
  this otherwise.  Thanks to Olivier Mehani and Francois Charlier.
  (https://bugs.debian.org/812785).  This also solves
  Ubuntu https://bugs.launchpad.net/ubuntu/+source/lbdb/+bug/1539774
  RedHat https://bugzilla.redhat.com/show_bug.cgi?id=1259881
- Fix several man page typos.


## [0.39] - 2014-05-10

### Added

- mutt-ldap-query: Add parameters for TLS and SASL_MECH (Thanks to
  Alexandra N. Kossovsky) (https://bugs.debian.org/512074).

### Fixed

- Update packaged autotools files.
- Rebuild aclocal/autoconf.
- Add $CPPFLAGS to $CFLAGS to really use hardening.
- m_vcf: Optimize missing names handling (Thanks to Jamey Sharp)
  (https://bugs.debian.org/633920).
- m_abook: fix formatting (Thanks to Alfredo Finelli)
  (https://bugs.debian.org/681526).
- Mention user mutt-ldap-query configuration files in lbdbq(1) man page
  (https://bugs.debian.org/534710).
- Update ABQuery build mechanism (Thanks to Brendan Cully).

## [0.38] - 2011-06-25

### Added

- m_vcf: Apply patch by Jamey Sharp <jamey@minilop.net> to support VCF
  contacts without real name (https://bugs.debian.org/624590).
- vcquery: Apply patch by martin f krafft <madduck@debian.org> to search
  in NICKNAME field, too. (https://bugs.debian.org/586300).

### Fixed

- m_evolution: Try to evaluate the location of
  evolution-addressbook-export at runtime, since it is no longer
  available in /usr/bin since evolution 2.30.1.2-3
  (https://bugs.debian.org/583851, #598380).

## [0.37] - 2010-05-18

### Added

- m_evolution: support line breaks and long lines.  Thanks to Jan Larres
  <jan@majutsushi.net> for providing a patch (https://bugs.debian.org/505540).

### Fixed

- Fix bashisms in m_bbdb (https://bugs.debian.org/530113).
- Fix query shell functions to catch non-zero exit status in case they
  get invoked in set -e context.  Thanks to martin f. krafft
  <madduck@debian.org> for providing a patch (https://bugs.debian.org/515076).
- Fix documentation concerning the quotes on lbdbq call
  (https://bugs.debian.org/542012).

## [0.36] - 2008-06-14

### Fixed

- Remove duplicate "See also: mutt" from lbdbq.man
  (https://bugs.debian.org/441588).
- Update configure using autconf 2.61.
- Apply charset conversation patch by Peter Colberg based on code by
  Tobias Schlemmer (https://bugs.debian.org/355678).
- Remove duplicate declaration of $ignorant
  (https://bugs.debian.org/480356, https://bugs.debian.org/483701).
- Handle mail addresses in mutt_ldap_query correct. Thanks to Colin
  Watson <cjwatson@debian.org> for providing a patch
  (https://bugs.debian.org/469288).
- Mention ldapi URIs in mutt_ldap_query man page
  (https://bugs.debian.org/422730).
- Protect "make distclean" by checking whether makefile exists.

## [0.35.1+nmu1] - 2008-04-12

### Fixed

- Fix m_evolution to work also with recent Evolution which exports cards
  with different FN/EMAIL fields ordering. Thanks to Brian M. Carlson for
  the patch (https://bugs.debian.org/462573).

## [0.35.1] - 2007-05-28

### Fixed

- Get rid of the SSL code from the previous version and add a comment to
  the man page instead how you can use SSL (and also different ports)
  using ldap[s]://foo[:port] URLs (https://bugs.debian.org/426316).

## [0.35] - 2007-05-20

### Added

- Update mutt_ldap_query.pl from
  http://www.courville.org/mediawiki/index.php/Mutt_ldap_query which
  adds SSL support.

### Fixed

- Avoid loosing the first entry from VCF file.  Thanks to
  Tino Keitel <tino.keitel+debbugs@tikei.de> for providing a patch
  (https://bugs.debian.org/405312).
- Remove vcquery in distclean target (https://bugs.debian.org/405321).
- Use defaults for $KEEP_DUPES and $SORT_OUTPUT in lbdbq
  (https://bugs.debian.org/422214).

## [0.34] - 2006-11-12

### Added

- vcquery: Use value of concatenated N fields if FN field is missing.
  Thanks to Gregor Jasny <gjasny@web.de> for providing a patch
  (https://bugs.debian.org/395422).

### Fixed

- vcquery: avoid free() on unallocated memory if fullname is not set.
  Thanks to Gregor Jasny <gjasny@web.de> for finding and providing a
  patch (https://bugs.debian.org/395421).

## [0.33] - 2006-10-14

### Added

- Add SORT_OUTPUT=reverse_comment to do reverse sort by the third column
  (most recent m_inmail timestamp at the top).  Thanks to Marco d'Itri
  for this suggestion.

### Fixed

- Comment out LDAP_NICKS in lbdb.rc because this should only be an
  example and if it is set there it overrides other LDAP settings
  (https://bugs.debian.org/391320).

## [0.32] - 2006-08-13

### Added

- New version of mutt_ldap_query by Marc de Courville
  <marc@courville.org> and other contributors.
- Extend lbdb_hostname() to get the domain name from resolv.conf.  Thanks
  to Gary Johnson <garyjohn@spk.agilent.com> for providing this patch.
- m_muttalias: Allow \"...\" around real names of aliases.  Thanks to
  Erik Shirokoff <shiro@berkeley.edu> for providing this patch.

### Fixed

- Change sort(1) syntax to cope with new versions of coreutils
  (https://bugs.debian.org/368917).

## [0.31.1] - 2006-01-15

### Fixed

- It seems, that evolution-addressbook-export now also has EMAIL entries
  without subtype "EMAIL;TYPE=INTERNET:" vs. "EMAIL:" in it. m_evolution
  now supports both variants (https://bugs.debian.org/347971).
- Remove backslash from comment in m_evolution.

## [0.31] - 2005-10-29

### Added

- Add m_vcf module for querying vcard files provided by Brendan Cully.
- Add authentication (bind_dn, bind_password) to mutt_ldap_query. Based
  on an idea of Jan-Benedict Glaw (https://bugs.debian.org/324655,
  https://bugs.debian.org/286163).

### Fixed

- m_pine: Double-quote parentheses.  Thanks to Stefan Mätje for reporting
  this bug and sending a patch.
- Apply patch by Brendan Cully to follow the Apple build system changes
  used to build ABQuery module.
- Update FSF address in nearly all files.

## [0.30] - 2005-04-30

### Fixed

- Get rid of strict aliasing warnings in gcc.  Thanks to Ludwig Nussel
  <ludwig.nussel@suse.de> for providing a patch.
- Add line breaks to POD part of mutt_ldap_query.pl to make man page
  more readable.
- Replace "grep" with "grep -a" to avoid error messages on non-ascii
  output (https://bugs.debian.org/284119).
- mutt_ldap_query: Stop returning entries without email address
  (https://bugs.debian.org/290148).
- m_gpg: Add support for gpg 1.4 (not only 1.2.5)
  (https://bugs.debian.org/294113).
- m_gpg: Stop showing revoked user ids (https://bugs.debian.org/259212).
- Rebuild configure with autoconf 2.59a.
- Make the paths of several binaries configurable in configure as
  --with-foo
- Replace hyphens (-) by minus signs (\-) in the man pages.

## [0.29] - 2004-02-23

### Added

- Add new module m_evolution to access Ximian Evolution addressbook.
  Thanks to Guido Guenther <agx@debian.org> (https://bugs.debian.org/234345).

## [0.28.2] - 2004-02-07

### Added

- Another upgrade of m_bbdb by Aaron Kaplan <kaplan@cs.rochester.edu>.
- mutt_ldap_query: Apply patch from Max Kutny <mkut@umc.ua>, which
  allows to override config file settings via command line options
  (https://bugs.debian.org/231261).

### Fixed

- Quote $GNUCLIENT in m_bbdb to avoid error message when this variable
  is not defined (https://bugs.debian.org/231061).

## [0.28.1] - 2004-01-18

### Added

- Allow sorting the output by "comment" field (column 3) by setting
  SORT_OUTPUT=comment (https://bugs.debian.org/225104).
- Add gnuclient support to m_bbdb module.  Thanks to Aaron Kaplan
  <kaplan@cs.rochester.edu> for providing this patch.

### Fixed

- Make m_osx_addressbook compile on MacOS 10.3 and XCode, too.  Thanks
  to Yuval Kogman <nothingmuch@woobling.org> and Brendan Cully
  <brendan@kublai.com> for the patch.
- Remove "set -e" from lbdbq, which causes trouble if grep doesn't find
  a match in some of the modules (https://bugs.debian.org/222647).
- m_passwd: Ignore system accounts (UIDs, which aren't in the range
  1000-29999 on a Debian system), if PASSWD_IGNORESYS=true is set
  (https://bugs.debian.org/188085).

## [0.28] - 2003-09-09

### Changed

- m_abook: Search for $HOME/.abook/addressbook in addition to
  $HOME/.abook.addressbook to honor the fact that this file was moved in
  abook 0.5 (https://bugs.debian.org/205418).

### Fixed

- Fix bug in ABQuery module, which crashes when it finds results in
  non-latin character sets.  Now returns UTF8 results instead.  Thanks
  to Brendan Cully <brendan@kublai.com>.
- Correct delimiter of vcard to END:VCARD in m_gnomecard and allow
  encodings etc. in the FN field, thanks to Rogerio Brito
  <rbrito@ime.usp.br> (https://bugs.debian.org/198633).
- Search for .gnome/GnomeCard.gcd in $HOME instead of current directory.
- Add a new version of mutt_ldap_query.pl by Marc de Courville:
  - activated pod2usage (now contained in all the decent distributions)
  - cleaned pod section to comply better with the pod formatting standard
  - change contact address
  - fixed typos
- m_palm: Use only "email" entries as e-mail addresses and not
  everything including "@".  Thanks to Nikolaus Rath <Nikolaus@rath.org>
  for providing the patch (https://bugs.debian.org/196888).

## [0.27] - 2003-03-22

### Added

- New module m_osx_addressbook, which queries the OS X AddressBook (only
  on OS X with the Developer tools installed) written by Brendan Cully
  <brendan@kublai.com>.

## [0.26.2] - 2003-02-09

### Added

- mutt_ldap_query: Add new config option $ignorant (and also 7th field in
  NICK array) to enable ignorant searching (search for *foo* instead of
  foo) (https://bugs.debian.org/179861).

### Fixed

- Optimized manual page in mutt_ldap_query.pl, to look less corrupted.

 -- Roland Rosenfeld <roland@debian.org>  Sun,  9 Feb 2003 13:19:49 +0100

## [0.26.1] - 2003-02-08

### Added

- Support multiple address book files with abook.  Thanks to Etienne
  PIERRE <marluchon@netcourrier.com> for providing this patch.

### Fixed

- Rebuild configure with autoconf 2.57.
- Add long options --version and --help to ldbdq and man page.
- New mail address of Brian Salter-Duke <b_duke@octa4.net.au>.
- Use /etc/mailname as mail domain name in lbdb_hostname()
  (https://bugs.debian.org/165159).

## [0.26] - 2002-02-11

### Added

- m_wanderlust: new module to read ~/.addesses file from WanderLust
  MUA.  Module provided by Gergely Nagy <algernon@debian.org>.
  (https://bugs.debian.org/133209).

### Fixed

- m_finger: Suppress lines where real name is '???' (some versions of
  finger seem to use this for non existing users)
  (https://bugs.debian.org/112127).
- Quote the search string in m_yppasswd, m_nispasswd and m_getent as
  mentioned by Gary Johnson <garyjohn@spk.agilent.com>.
- Add CVS Id tags to all modules.

## [0.25.2] - 2001-09-01

### Added

- Add m_getent by Adrian Likins <alikins@redhat.com>, which can replace
  m_passwd and m_yppasswd on systems where getent(1) is installed.

### Fixed

- New version (1.10) of lbdb.el by Dave Pearson <davep@davep.org>:
  Fixes the fact that, when in an emacs that doesn't have
  `line-{beginning,end}-position' available (xemacs, for example) I
  wasn't defining fully compatible versions.
- Add short description to mutt_ldap_query in NAME section.
- Add option -a to fetchaddr and lbdb-fetchaddr to fetch also addresses
  without realname.

## [0.25.1] - 2001-07-24

### Fixed

- Add ">" to pod2man call in Makefile, because older versions of perl
  come with a pod2man which dies otherwise.

## [0.25] - 2001-07-22

### Added

- Add m_ldap and mutt_ldap_query provided by Marc de Courville,
  <marc@courville.org>.
- Module m_nispasswd added by Utz-Uwe Haus <haus@uuhaus.de>.

### Changed

- Added variable MAIL_DOMAIN_NAME to override other settings of mail
  domain.

### Fixed

- Fix problem in mutt_ldap_query, which ignored the content of the
  config file before.
- Remove <> from email address in mutt_ldap_query output.
- lbdb-munge didn't honor SORT_OUTPUT when called from m_inmail, so
  export this variable in m_inmail (https://bugs.debian.org/92767).

## [0.24] - 2001-02-10

### Added

- Add new module m_bbdb to access a (X)Emacs big brother database (bbdb)
  from lbdb using (x)emacs as the backend.  Thanks to Utz-Uwe Haus
  <haus@uuhaus.de> for providing this.

### Changed

- Add a new variable KEEP_DUPES, which allows to see duplicate mail
  addresses (with different real names or comment fields)
  (https://bugs.debian.org/83908).

### Fixed

- s/MODULE_PATH/MODULES_PATH/ in documentation to match the behavior of
  the program (https://bugs.debian.org/83933).
- m_gpg: stop using --with-colons, because this outputs utf8 instead of
  your local charset, which causes problems with non 7bit characters
  (https://bugs.debian.org/83936).

## [0.23] - 2001-01-23

### Added

- Add new module m_gnomecard based on an idea by Rick Frankel
  <rick@rickster.com>.
- Upgrade lbdb.el to version 1.9 (Thanks Dave!).

### Fixed

- Add a second grep to m_pgp5 and m_gpg to remove UIDs, which don't
  match the search string, but are only generated, because a different
  UID of this key matches.
- Add $(install_prefix) to Makefile.in.  Thanks to Rob Payne
  <rnspayne@adelphia.net> for providing the idea and a patch.
- Update lbdb.spec.in, patch provided by Rob Payne
  <rnspayne@adelphia.net>.

## [0.22] - 2000-10-17

### Added

- Add new module m_addr_email to request data from addressbook program
  (http://red.roses.de/~clemens/addressbook/) by Torsten Jerzembeck
  <toje@nightingale.ms.sub.org>.
- Update lbdb.el to version 1.8:
  - Fixes the problem with spaces in query strings
    (https://bugs.debian.org/74818).
  - New commands lbdb-region and lbdb-maybe-region to query lbdb for the
    content of the current region.
  - Autoload lbdb-region and lbdb-maybe-region from startup file.

### Fixed

- Some optimizations on m_addr_email to handle city name correct and to
  junk entries without email address.
- Use sort without -u option, because duplicates are already removed by
  munge before.
- Do not overwrite m_inmail.list on munging, if file system is full.

## [0.21.1] - 2000-10-09

### Added

- SORT_OUTPUT now can be "name" or "address" to sort output by mail
   real names or addresses (still the default).

### Fixed

- Update lbdb.el to version 1.4 to avoid problems with status line of
  lbdbq.
- Correct behavior of variable SORT_OUTPUT (did the inverse of what it
  should do).
- Correct output of number of matching entries (count after munging
  instead before).

## [0.21] - 2000-10-08

### Added

- Update lbdb.el to version 1.3 (thanks Dave).
- m_muttalias: Add support for "alias foo <foo@bar> (Foo Bar)" style
  aliases.

### Fixed

- Don't fail in m_palm, if no database is available.
- Correct typo in m_muttalias, which stopped to work when your HOME is
  your MUTT_DIRECTORY (https://bugs.debian.org/71975).
- Correct README (we have more than two modules now :-)
- Create sysconfdir, if it doesn't already exist.
- lbdbq: write information about number of matching entries into status
  line and exit with return value 1, if no matching entries were found.
- Correct exit value of lbdbq (trap command).

## [0.20.1] - 2000-08-24

### Fixed

- Fix name conflicts (m_palm_lsaddr now completely renamed to
  palm_lsaddr).

## [0.20] - 2000-08-21

### Added

- Add emacs interface lbdb.el 1.2 by Dave Pearson <davep@davep.org>
- Add m_palm module and palm_lsaddr by Dave Pearson <davep@davep.org>.

### Fixed

- Update documentation.
- Rename $p to $CURRENT_MODULE_DIR in lbdbq, so a module can access the
  directory where it is placed itself for accessing some helper
  applications.

## [0.19.9] - 2000-08-16

### Fixed

- Remove erroneous quotes from lbdb-fetchaddr, which caused fetchaddr to
  write "`' wrong parameter" error message to procmail log file.
- Correct the getopt behavior in lbdb-fetchaddr.
- s/strfcpy/strncpy/ in fetchaddr.c.

## [0.19.8] - 2000-08-08

### Fixed

- Renamed option -h to -x, because -h is already used for "help".

## [0.19.7] - 2000-08-07

### Added

- Add a new option -h to lbdb-fetchaddr and fetchaddr, which allows you
  to add a colon separated list of header fields to search for mail
  addresses.  If this option isn't given, we fall back to
  "from:to:cc:resent-from:resent-to" (https://bugs.debian.org/54169).

## [0.19.6] - 2000-08-05

### Added

- New version of m_pine by Gabor Fleischer <flocsy@mtesz.hu>: Now
  handles aliases without real names correct (by using a single space as
  the realname, so Mutt has not problem with this.
- Add new helper program qpto8bit, which converts quoted-printable
  (according to RFC2047) to plain 8bit (without MIME header).  This is
  used by m_pine to decode quoted-printable in addressbooks to 8bit.

## [0.19.5] - 2000-06-23

### Added

- Add new module m_pine, provided by Gabor FLEISCHER <flocsy@mtesz.hu>
  to search pine address books.

### Fixed

- Remove "-f" option from configure @AWK@ variable and manually add it,
  where it is needed, otherwise @AWK@ cannot be used for inline scripts.
- Fixed m_muttalias to additionally accept "foo@bar (Foo Bar)" style
  addresses and to ignore group aliases.

## [0.19.4] - 2000-05-28

### Fixed

- Make dotlock.c compile on systems without snprintf() again.
- Don't remove Makefile in clean target but only in distclean.

## [0.19.3] - 2000-05-27

### Added

- Add new module m_muttalias, provided by Brian Salter-Duke
  <b_duke@lacebark.ntu.edu.au> to search mutt alias files for aliases.

## [0.19.2] - 2000-05-22

### Changed

- Give the dateformat to fetchaddr(1) using the -d option (instead of
  simply using argv[1]).
- Give the dateformat to lbdb-fetchaddr(1) using the -d option.  If
  there is only one parameter, this is used as dateformat for backward
  compatibility.  Manpage adapted to this.

### Fixed

- Remove DOTLOCK=/usr/bin/mutt_dotlock from ./configure environment.
  This is superfluous since --enable-lbdb-dotlock is used, but it
  doesn't cause problems (neither with mutt installed or deinstalled)
  (https://bugs.debian.org/64134).
- Fixed typo in m_abook ("@$" instead of "$@").

## [0.19] - 2000-05-08

### Added

- Add abook support based on an idea by Ross Campbell
  <rcampbel@us.oracle.com>.
- Add NIS support based on an idea by Ross Campbell
  <rcampbel@us.oracle.com>.
- Add lbdb.spec by Horms <horms@vergenet.net>.
- Update the version number in lbdb.spec via configure.
- Add option SORT_OUTPUT to lbdb.rc, which can be set to "false" or
  "no".  This implies that lbdbq doesn't sort the output but reverts its
  order, so the most recent addresses from m_inmail.list will be shown
  first.  Thanks to Andrew Over <aover@uq.net.au> for this idea.

### Fixed

- use safe_strdup() instead of strdup() which isn't available on Ultrix.
- Add --enable-lbdb-dotlock to configure options to force using of
  lbdb_dotlock (instead of using mutt_dotlock) and use this option for
  the Debian package (https://bugs.debian.org/58188).
- Update FSF address in copyrights.
- Update dotlock code from mutt 1.1.12.
- Speed up munge (nearly two times as fast as previous version).

 -- Roland Rosenfeld <roland@debian.org>  Mon,  8 May 2000 19:23:16 +0200

## [0.18.5] - 1999-11-07

### Fixed

- Optimized m_gpg to use --with-colons.

## [0.18.4] - 1999-10-24

### Fixed

- Fixed typo in lbdb-fetchaddr.man.
- Fixed typo on lbdbq.man (https://bugs.debian.org/48143).

## [0.18.3] - 1999-09-18

### Fixed

- m_gpg no longer writes error messages to stderr, when the given search
  string does not exist (https://bugs.debian.org/45422).

## [0.18.2] - 1999-09-15

### Added

- Added HP-UX support (by David Ellement <ellement@sdd.hp.com>):
  - Try awk (in addition to mawk, gawk, nawk).
  - Don't use "if ! ..." in shell scripts, because ksh in HP-UX doesn't
    support this.
- Add -v and -h options to lbdbq and lbdb-fetchaddr which display the
  version of lbdb and a short help.

### Fixed

- Make dotlock.c more portable.
- Make Makefile.in much more portable.
- Merge in changes of dotlock program from Mutt 0.96.6.

## [0.18.1] - 1999-08-04

### Security

- Merged in changes from Mutt's dotlock (CVS as of 1999-08-01).

### Fixed

- Use "$@" instead of $1 in m_* files to allow `lbdb First Last' without
  quotes around "First Last" (https://bugs.debian.org/42417).

## [0.18] - 1999-06-23

### Added

- Added Fido module m_fido and nodelist2lbdb.

### Changed

- Splited lbdb-fetchaddr.man off from lbdbq.man.
- Moved lbdb-fetchaddr from $bindir to $libdir.

## [0.17.1] - 1999-05-25

### Fixed

- Upgraded autoconf from 2.12 to 2.13.
  Get rid of `echo $PATH | sed "s/:/ /g"` in AC_PATH_PROC() macro,
  because this isn't needed and doesn't work with autoconf 2.13.
- Removed word boundary check in m_inmail, because this is only
  available in GNU grep.

## [0.17] - 1999-04-07

### Added

- Delay munging of mails when using lbdb-fetchaddr/m_inmail by adding a
  new script lbdb-munge, which is run by lbdbq and can be run by cron
  additionally. Thanks to Enrico Zini <zinie@cs.unibo.it> for the base
  idea of this.

### Changed

- Made lbdb-fetchaddr Y2K compliant by changing the date format which is
  written to the 3rd column of m_inmail.list to "%Y-%m-%d %H:%M" (e.g.
  "1999-04-29 14:33").
- Made date format in lbdb-fetchaddr runtime configurable as a command
  line parameter. If no date format is specified, "%Y-%m-%d %H:%M" is
  used as the default.

### Fixed

- include getopt.h only if it is existing (using autoconf).

## [0.16.2] - 1999-04-06

### Fixed

- Removed some bash, GNU-make, and GNU libc specials.

## [0.16.1] - 1999-04-05

### Fixed

- lbdb-fetchaddr: Create directory $HOME/.lbdb if it does not exist.

## [0.16] - 1999-04-04

### Fixed

- Added dotlock command from mutt 0.96.1 sources (without the SGID mail
  stuff) which is installed as lbdb_dotlock, when no mutt_dotlock can be
  found.

## [0.15.1] - 1999-02-21

### Added

- m_passwd: give UID in comment field.

### Fixed

- m_gpg: now only return addresses which match
  query. https://bugs.debian.org/33672.

## [0.15] - 1999-02-18

### Added

- Added new modules:
  - m_passwd: looks into /etc/passwd for addresses
  - m_pgp2:   scans your PGP 2.* keyring for addresses
  - m_pgp5:   scans your PGP 5.* keyring for addresses
  - m_gpg:    scans your GnuPG keyring for addresses

### Fixed

- Made config directory autoconf configureable as @sysconfdir@
- Fixed trouble in configure.in noted by Fabrice Noilhan
  <noilhan@clipper.ens.fr>.

## [0.14] - 1999-01-16

### Fixed

- fetchaddr converts the domain part of mail addresses to lowercase, to
  beware of duplicates in m_inmail.list. https://bugs.debian.org/31989

## [0.13] - 1999-01-12

### Added

- Upgraded lbdb.sl supplied by Thomas Roessler <roessler@guug.de>

### Changed

- Moved lbdb.sl to /usr/doc/lbdb/examples
- Create ~/.lbdb/m_inmail.list in lbdb-fetchaddr if it does not exist.

### Fixed

- Fix manpage lbdb-fetchaddr(1) to refer to the correct db filename.

## [0.12] - 1998-11-11

### Changed

- Package maintenance transferred from Thomas Roessler to Roland Rosenfeld

### Fixed

- lbdbq manpage moved to main packet.
- made @libdir@ configurable in lbdbq manpage.
- fixed some "-Wall" warnings.
- several typos and nits fixed.

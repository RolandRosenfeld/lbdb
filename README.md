The Little Brother's Database (lbdb)
====================================

- Roland Rosenfeld <roland@spinnaker.de> (current maintainer)
- Thomas Roessler <roessler@guug.de> (initial author)

This package was inspired by the
[Big Brother Database](http://bbdb.sourceforge.net/) package available
for various Emacs mailers, and by Brandon Long's
["external query"](http://www.mutt.org/doc/manual/#query) patch for the
[Mutt](http://www.mutt.org/) mail user agent.
(Note that this patch has been incorporated into the main-line mutt
versions as of mutt 0.93.)

The package doesn't use any formal database libraries or languages,
although it should be quite easy to extend it to use, e.g., an installed
PostgreSQL server as it's back end.

For querying the Little Brother, just type `lbdbq <something>`.  lbdbq
will now attempt to invoke various modules to gather information about
persons matching `<something>`.  E.g., it may look at a list of
addresses from which you have received mail, it may look at YP maps,
or it may try to finger `<something>@<various hosts>`.

The behavior is configurable: Upon startup, lbdbq will source the
shell scripts

- `/usr/local/etc/lbdb.rc` (or where your sysconfdir points to)
- `$XDG_CONFIG_HOME/lbdb/config`
- `$HOME/.lbdbrc`
- `$HOME/.lbdb/lbdbrc`
- `$HOME/.lbdb/rc`

if they exist.

They can be used to set the following global variables:

- `MODULES_PATH`: Where lbdbq should look for modules
- `METHODS`: What modules to use.
- `SORT_OUTPUT`: Set this to "false" or "no" and lbdbq won't sort the
  addresses but returns them in reverse order (which means that the
  most recent address in m_inmail database is first).  If you set this
  to "name", lbdbq sorts the output by real name.  If you set this to
  "comment", it sort the output by the comment (for example the date
  in m_inmail).  If you set this to "address", lbdbq sorts the output
  by addresses (that's the default).

Note that there _are_ defaults, so you should most probably modify
these variables using constructs like this:
```
MODULES_PATH="MODULES_PATH $HOME/lbdb_modules"
```

Additionally, modules may have configuration variables of their own.

Currently the following modules are supplied with lbdb:

Modules
-------

### m_finger

This module will use finger to find out something more about a person.
The list of hosts do be asked is configurable; use the
`M_FINGER_HOSTS` variable.  Note that "localhost" will mean an
invocation of your local finger(1) binary, and should thus work even
if you don't provide the finger service to the network.  m_finger
tries to find out the machines mail domain name in /etc/mailname, by
parsing a sendmail.cf file (if it finds one) and by reading
/etc/hostname and /etc/HOSTNAME.

### m_inmail

This module will look up user name fragments in a list of mail
addresses.  To create this list, put the following lines into your
\$HOME/.procmailrc:
```
:0hc
| lbdb-fetchaddr
```

This will pipe a copy of every mail message you receive through a
small C program lbdb-fetchaddr(1) which grabs that message's "From:"
header.

### m_passwd

This module searches for matching entries in your local /etc/passwd
file.  It evaluates the local machine mail domain in the same way
m_finger does.  If you set PASSWD_IGNORESYS=true, this module ignores
all system accounts and only finds UIDs between 1000 and 29999 (all
other UIDs are reserved on a Debian system).

### m_yppasswd

This module searches for matching entries in the NIS password database
using the command `ypcat passwd`.

### m_nispasswd

This module searches for matching entries in the NIS+ password
database using the command `niscat passwd.org_dir`.

### m_getent

This module searches for matching entries in whatever password
database is configured using the command `getent passwd`.

### m_pgp2, m_pgp5, m_gpg

These modules scan your PGP 2.*, PGP 5.* or GnuPG public key ring for
data.  They use the programs pgp, pgpk, or [gpg](http://www.gnupg.org)
to get the data.

### m_fido

This module searches your Fido nodelist, stored in
$HOME/.lbdb/nodelist created by nodelist2lbdb(1).

### m_abook

This module uses the program [abook](http://abook.sourceforge.net/), a
text based address book application to search for addresses.  You can
define multiple abook address books by setting the variable
ABOOK_FILES to a space separated list.

### m_goobook

This module uses the program
[goobook](https://pypi.python.org/pypi/goobook), a program to access
your Google contacts via command line client.

### m_addr_email

This module uses the program addr-email from the
[addressbook](https://web.archive.org/web/20121020003335/http://www.red.roses.de:80/~clemens/addressbook/)
Tk address database program to search for addresses.

### m_muttalias

This module searches the variable `$MUTTALIAS_FILES` (a space
separated list) of files in `$MUTT_DIRECTORY` that contain
[Mutt](../mutt/) aliases.  File names without leading slash will have
`$MUTT_DIRECTORY` (defaults to `$HOME/.mutt` or `$HOME`, if
`$HOME/.mutt` does not exist) prepended before the file name.
Absolute file names (beginning with `/`) will be taken direct.

### m_pine

This module searches [pine](http://www.washington.edu/pine/)
addressbook files for aliases.  To realize this it first inspects the
variable `$PINERC`.  If it isn't set, the default `"/etc/pine.conf
/etc/pine.conf.fixed .pinerc"` is used.  To suppress inspecting the
`$PINERC` variable, set it to `"no"`.  It than takes all
`address-book` and `global-address-book` entries from these pinerc
files and adds the contents of the variable `$PINE_ADDRESSBOOKS` to
the list, which defaults to `"/etc/addressbook .addressbook"`.  Then
these addressbooks are searched for aliases.  All filenames without
leading slash are searched in `$HOME`.

### m_palm

This module searches the Palm address database using the Palm::PDB and
Palm::Address Perl modules from [CPAN](http://www.cpan.org/).  It
searches in the variable `$PALM_ADDRESS_DATABASE` or if this isn't set
in `$HOME/.jpilot/AddressDB.pdb`.

### m_gnomecard

This module searches for addresses in your GnomeCard database files.
The variable `GNOMECARD_FILES` is a whitespace separated list of
GnomeCard data files.  If this variable isn't defined, the module
searches in `$HOME/.gnome/GnomeCard` for the GnomeCard database or at
least falls back to `$HOME/.gnome/GnomeCard.gcrd`.  If a filename does
not start with a slash, it is prefixed with `$HOME/`.

### m_bbdb

This module searches for addresses in your (X)Emacs
[BBDB](http://bbdb.sourceforge.net/) (big brother database).  It
doesn't access `~/.bbdb` directly (yet) but calls (x)emacs with a
special mode to get the information (so don't expect too much
performance in this module).  You can configure the `EMACS` variable
to tell this module which emacsen to use.  Otherwise it will fall back
to emacs or xemacs.

### m_ldap

This module queries an LDAP server using the Net::LDAP Perl modules
from [CPAN](http://www.cpan.org/).  It can be configured using an
external resource file (for more details please refer to the
mutt_ldap_query(1) manual page).

### m_wanderlust

This module searches for addresses stored in your
`$WANDERLUST_ADDRESSES` (or by default in `$HOME/.addresses`) file, an
addressbook of [WanderLust](http://www.gohome.org/wl/).

### m_osx_addressbook

This module queries the OS X AddressBook.  It is only available on OS X
systems.

### m_evolution

This module queries the Ximian Evolution address book using the
evolution-addressbook-export application.

### m_vcf

This module uses libvc or libvformat to search for addresses from the
space-separated set of vCard files defined in `$VCF_FILES`.

### m_khard

This module searches a CardDAV address book via
[khard](https://github.com/scheibler/khard).

### m_mu

This module uses the program
[mu](http://www.djcbsoftware.nl/code/mu/), a tool for indexing and
searching Maildir directories.  You can set `MU_AFTER` to a timestamp
value and `MU_PERSONAL` to "yes" or "true" to filter the results.

-----

Feel free to create your own modules to query other kind of databases.
`m_finger` should be a good example of how to do it.

If you create your own modules or have other changes and feel that
they could be helpful for others, don't hesitate to submit them to me
for inclusion in later releases.

For more information have a look at the lbdbq(1) man page, which is
included in the package.

Download and Repository:
------------------------

- [Download page](https://www.spinnaker.de/lbdb/download)
- [Changelog](https://www.spinnaker.de/lbdb/changelog)
- [Debian package](https://www.spinnaker.de/debian/lbdb.html)
- [Git repository](https://github.com/RolandRosenfeld/lbdb)

Credits:
--------

This package was initially written by Thomas Roessler <roessler@guug.de>.
Most of the really interesting code of this program (namely, the RFC 822
address parser used by lbdb-fetchaddr) was stolen from
Michael Elkins <me@cs.hmc.edu> [mutt](http://www.mutt.org) mail user agent.
Additional credits go to Brandon Long <blong@fiction.net> for
putting the [query](http://www.mutt.org/doc/manual/#query)
functionality into mutt.

Many thanks to the authors of the several modules and extensions:

- Ross Campbell <rcampbel@us.oracle.com>           (m_abook, m_yppasswd)
- Marc de Courville <marc@courville.org>           (m_ldap, mutt_ldap_query)
- Brendan Cully <brendan@kublai.com>               (m_osx_addressbook, m_vcf)
- Gabor Fleischer <flocsy@mtesz.hu>                (m_pine)
- Rick Frankel <rick@rickster.com>                 (m_gnomecard)
- Guido Guenther <agx@sigxcpu.org>                 (m_evolution)
- Utz-Uwe Haus <haus@uuhaus.de>                    (m_bbdb, m_nispasswd)
- Torsten Jerzembeck <toje@nightingale.ms.sub.org> (m_addr_email)
- Gergely Nagy <algernon@debian.org>               (m_wanderlust)
- Dave Pearson <davep@davep.org>                   (m_palm, lbdb.el)
- Brian Salter-Duke <b_duke@bigpond.net.au>        (m_muttalias)
- François Charlier <fcharlier@ploup.net>          (m_goobook)
- Colin Watson <cjwatson@debian.org>               (m_khard)
- Timothy Bourke <tim@tbrk.org>                    (m_mu)

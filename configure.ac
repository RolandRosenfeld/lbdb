dnl Copyright (c) 1998-2025 Roland Rosenfeld <roland@spinnaker.de>
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2 of the License, or
dnl (at your option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program; if not, write to the Free Software Foundation,
dnl Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.

AC_INIT([lbdb],
	0.56,
	[roland@spinnaker.de],
	[],
	[https://www.spinnaker.de/lbdb/])
AC_CONFIG_SRCDIR([fetchaddr.c])

AC_MSG_CHECKING(for prefix)
if test x$prefix = xNONE; then
	lbdb_cv_prefix=$ac_default_prefix
else
	lbdb_cv_prefix=$prefix
fi
AC_MSG_RESULT($lbdb_cv_prefix)

AC_PROG_CC
AC_PROG_INSTALL

AC_CHECK_HEADER(getopt.h, AC_DEFINE(HAVE_GETOPT_H))

AM_ICONV

dnl SH=NONE

dnl If we are runnin bash right now, BASH is set.
unset BASH

if test "x$SH" = x ; then
	AC_PATH_PROG(BASH, bash, NONE)
	if test ! "x$BASH" = xNONE ; then
		if $BASH -posix -c true ; then
			SH="$BASH -posix"
		elif $BASH --posix -c true ; then
			SH="$BASH --posix"
		fi
		echo "Using $SH".
	fi
fi

if test "x$SH" = x ; then
	AC_PATH_PROG(KSH, ksh, NONE)
	if test ! "x$KSH" = xNONE ; then
		SH="$KSH"
		echo "Using $SH".
	fi
fi

if test "x$SH" = x ; then
	AC_PATH_PROG(BINSH, sh, NONE)
	if test "x$BINSH" = xNONE; then
		echo "ERROR: Can't find sh." >&2
		exit 1
	else
		SH="$BINSH"
	fi
fi

AC_SUBST(SH)

AC_PATH_PROG(AWK, awk, NONE)
AC_PATH_PROG(MAWK, mawk, NONE)
AC_PATH_PROG(GAWK, gawk, NONE)
AC_PATH_PROG(NAWK, nawk, NONE)

if test "x$AWK" != "xNONE" ; then
	AWK="$AWK"
fi

if test "x$NAWK" != "xNONE" ; then
	AWK="$NAWK"
fi

if test "x$GAWK" != "xNONE" ; then
	AWK="$GAWK"
fi

if test "x$MAWK" != "xNONE" ; then
	AWK="$MAWK"
fi

AC_SUBST(AWK)

AC_PATH_PROG(TAC, tac, NONE)
if test "x$TAC" = "xNONE"; then
	TACTARGET="tac"
	AC_SUBST(TACTARGET)
	TACAWK="tac.awk"
	TAC="$libexecdir/tac"
fi
AC_SUBST(TAC)

AC_ARG_ENABLE(lbdb_dotlock,
	      AS_HELP_STRING ([--enable-lbdb-dotlock],
		 	      [Force use of lbdb_dotlock program]),
              [lbdb_cv_lbdb_dotlock="$enableval"])

AC_PATH_PROG(DOTLOCK_OLD, mutt.dotlock, no)
if test x$ac_cv_path_DOTLOCK_OLD = xno ; then
	AC_PATH_PROG(DOTLOCK, mutt_dotlock, no)
else
	ac_cv_path_DOTLOCK=$ac_cv_path_DOTLOCK_OLD
fi

if test x$ac_cv_path_DOTLOCK = xno || test x$lbdb_cv_lbdb_dotlock = xyes
then
	DOTLOCK_TARGET="lbdb_dotlock"
	AC_SUBST(DOTLOCK_TARGET)
	DOTLOCK="$bindir"/lbdb_dotlock
fi

AC_SUBST(DOTLOCK)

DOTLOCKBASE=`basename $DOTLOCK`
AC_SUBST(DOTLOCKBASE)

path_fetchaddr="$libexecdir/fetchaddr"
AC_SUBST(path_fetchaddr)

#
# LBDB_ARG_WITH(FOO, foo, m_foo, [with foo support])
#
# several cases:
# --with-foo        - search for foo in PATH. error if not found
# --with-foo=/foo   - use /foo
# --without-foo     - completely disable this
# none of the above - search for foo in PATH. disable if not found
#
AC_DEFUN([LBDB_ARG_WITH], [
    withval=""
    AC_ARG_WITH($2,[AS_HELP_STRING([--with-$2],[$4])])
    if test x$withval = xyes; then
        AC_PATH_PROG($1, $2, "no")
        if test x$$1 = xno; then
	    AC_MSG_ERROR([$2 not in PATH])
        else
    	    MODULES="$MODULES $3"
	    AC_SUBST($1)
        fi
    elif test x$withval = x; then
        AC_PATH_PROG($1, $2, "no")
        if test x$$1 != xno; then
      	    MODULES="$MODULES $3"
    	    AC_SUBST($1)
        fi
    elif test x$withval != xno; then
        $1=$withval
        MODULES="$MODULES $3"
        AC_SUBST($1)
    fi
])

MODULES="m_inmail m_passwd m_muttalias m_pine m_gnomecard m_bbdb m_wanderlust"

LBDB_ARG_WITH(FINGER, finger, m_finger, [with finger support])
LBDB_ARG_WITH(ABOOK, abook, m_abook, [with abook support])
LBDB_ARG_WITH(GOOBOOK, goobook, m_goobook, [with goobook support])
LBDB_ARG_WITH(ADDR_EMAIL, addr-email, m_addr_email, [with addressbook support])
LBDB_ARG_WITH(YPCAT, ypcat, m_yppasswd, [with ypcat passwd support])
LBDB_ARG_WITH(NISCAT, niscat, m_nispasswd, [with niscat passwd support])
LBDB_ARG_WITH(GETENT, getent, m_getent, [with getent passwd support])
LBDB_ARG_WITH(GPG, gpg, m_gpg, [with GnuPG support])
LBDB_ARG_WITH(PGPK, pgpk, m_pgp5, [with PGP 5.* support])
LBDB_ARG_WITH(PGP, pgp, m_pgp2, [with PGP 2.* support])
LBDB_ARG_WITH(EVOLUTION_ADDRESSBOOK_EXPORT, evolution-addressbook-export,
              m_evolution, [with Evolution support ('auto' searchs at runtime)])
LBDB_ARG_WITH(KHARD, khard, m_khard, [with khard support])
LBDB_ARG_WITH(MU, mu, m_mu, [with mu (maildir-utils) support])

AC_PATH_PROG(PERL, perl, "no")
if test "x$PERL" != xno ; then
	# m_fido needs nodelist2lbdb, which needs perl
	# m_palm needs palm_lsaddr, which needs perl
	# m_ldap needs mutt_ldap_query, which is written in perl
	# m_vcf needs vcquery, which is written in perl
	MODULES="$MODULES m_fido m_palm m_ldap m_vcf"
	AC_SUBST(PERL)
fi

# m_osx_addressbook requires xcode (10.3) or projectbuilder (<10.3)
AC_PATH_PROG(XCODEBUILD, xcodebuild, "no")
if test "x$XCODEBUILD" != xno; then
	MODULES="$MODULES m_osx_addressbook"
	AC_SUBST(XCODEBUILD)
else
	AC_PATH_PROG(PBXBUILD, pbxbuild, "no")
	if test "x$PBXBUILD" != xno ; then
		MODULES="$MODULES m_osx_addressbook"
		AC_SUBST(PBXBUILD)
	fi
fi

MODULES_SH=""
for i in $MODULES ; do
	MODULES_SH="$MODULES_SH $i.sh"
done

# some voodoo to replace ${prefix} in perl script (mutt_ldap_query.pl):
SYSCONF_DIR=`test "$prefix" = NONE && prefix=$ac_default_prefix; eval echo "${sysconfdir}"`
AC_SUBST(SYSCONF_DIR)

LBDB_VERSION=$PACKAGE_VERSION
AC_SUBST(LBDB_VERSION)

LBDB_ELPA_VERSION=`echo $PACKAGE_VERSION|sed 's/+.*$//'`
AC_SUBST(LBDB_ELPA_VERSION)

AC_SUBST(MODULES)

AC_CONFIG_TESTDIR([tests])
AC_PATH_PROG(AUTOM4TE, autom4te, autom4te)
AC_SUBST(AUTOM4TE)

AC_CONFIG_FILES([Makefile lbdbq.sh munge.awk lbdb-fetchaddr.sh vcquery.pl \
	lbdb-munge.sh lbdb_lib.sh nodelist2lbdb.pl palm_lsaddr.pl \
	mutt_ldap_query.pl $MODULES_SH $TACAWK lbdb.spec lbdb.rc lbdb-pkg.el \
	tests/Makefile tests/atlocal])
AC_OUTPUT

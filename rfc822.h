/*
 * Copyright (C) 1996-2000 Michael R. Elkins <me@mutt.org>
 * Copyright (C) 2012 Michael R. Elkins <me@mutt.org>
 *
 *     This program is free software; you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation; either version 2 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License along
 *     with this program; if not, see <https://www.gnu.org/licenses/>.
 */

#ifndef rfc822_h
#define rfc822_h

#include <sys/types.h>

/* possible values for RFC822Error */
enum
{
  ERR_MEMORY = 1,
  ERR_MISMATCH_PAREN,
  ERR_MISMATCH_QUOTE,
  ERR_BAD_ROUTE,
  ERR_BAD_ROUTE_ADDR,
  ERR_BAD_ADDR_SPEC,
  ERR_BAD_LITERAL
};

typedef struct address_t
{
#ifdef EXACT_ADDRESS
  char *val;		/* value of address as parsed */
#endif
  char *personal;	/* real name of address */
  char *mailbox;	/* mailbox and host address */
  int group;		/* group mailbox? */
  struct address_t *next;
  unsigned is_intl      : 1;
  unsigned intl_checked : 1;
}
ADDRESS;

void rfc822_dequote_comment (char *s);
void rfc822_free_address (ADDRESS **);
void rfc822_qualify (ADDRESS *, const char *);
ADDRESS *rfc822_parse_adrlist (ADDRESS *, const char *s);
ADDRESS *rfc822_cpy_adr (ADDRESS *addr, int);
ADDRESS *rfc822_cpy_adr_real (ADDRESS *addr);
ADDRESS *rfc822_append (ADDRESS **a, ADDRESS *b, int);
int rfc822_write_address (char *, size_t, ADDRESS *, int);
void rfc822_write_address_single (char *, size_t, ADDRESS *, int);
void rfc822_free_address (ADDRESS **addr);
void rfc822_cat (char *, size_t, const char *, const char *);
int rfc822_valid_msgid (const char *msgid);
int rfc822_remove_from_adrlist (ADDRESS **a, const char *mailbox);

const char *rfc822_parse_comment (const char *, char *, size_t *, size_t);


extern int RFC822Error;
extern const char * const RFC822Errors[];

#define rfc822_error(x) RFC822Errors[x]
#define rfc822_new_address() safe_calloc(1,sizeof(ADDRESS))

#endif /* rfc822_h */

/*
 *  Copyright (c) 1998 Thomas Roessler <roessler@guug.de>
 * 
 *  This file contains the prototypes for several of the
 *  functions from helpers.c.  It is part of the "little
 *  brother database" packet.
 * 
 *  These functions have been stolen from the mutt mail
 *  user agent.  The copyright notice from there:
 * 
 *  Copyright (C) 1996-8 Michael R. Elkins <me@cs.hmc.edu>
 * 
 *     This program is free software; you can
 *     redistribute it and/or modify it under the terms
 *     of the GNU General Public License as published by
 *     the Free Software Foundation; either version 2 of
 *     the License, or (at your option) any later
 *     version.
 * 
 *     This program is distributed in the hope that it
 *     will be useful, but WITHOUT ANY WARRANTY; without
 *     even the implied warranty of MERCHANTABILITY or
 *     FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *     General Public License for more details.
 * 
 *     You should have received a copy of the GNU General Public License
 *     along with this program; if not, write to the Free Software Foundation,
 *     Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301,, USA.
 */

#ifndef _HELPERS_H
#define _HELPERS_H

#include <ctype.h>
#include <sys/types.h>
#include <string.h>
#include "rfc822.h"

char *safe_strdup (const char *);
void *safe_calloc (size_t, size_t);
void *safe_malloc (unsigned int);
void safe_realloc (void **, size_t);
void safe_free (void *);
size_t safe_strlen (const char *);
int safe_strcmp (const char *, const char *);

#define FREE(x) safe_free(x)
#define SKIPWS(c) while (*(c) && isspace ((unsigned char) *(c))) c++;
#define strfcpy(A,B,C) strncpy(A,B,C), *((A)+(C)-1)=0
# define NONULL(x) x?x:""

#define STRING 		256
#define LONG_STRING    1024

#define EMAIL_WSP " \t\r\n"

/* skip over WSP as defined by RFC5322.  This is used primarily for parsing
 * header fields. */

static inline char *skip_email_wsp(const char *s)
{
  if (s)
    return (char *)(s + strspn(s, EMAIL_WSP));
  return (char *)s;
}

static inline int is_email_wsp(char c)
{
  return c && (strchr(EMAIL_WSP, c) != NULL);
}

#define ascii_strcmp(a,b) safe_strcmp(a,b)
int ascii_strcasecmp (const char *a, const char *b);


static inline const char *mutt_addr_for_display (ADDRESS *a)
{
  return a->mailbox;
}

#endif

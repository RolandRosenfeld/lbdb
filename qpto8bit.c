/*
 *  Copyright (C) 2000-2025  Roland Rosenfeld <roland@spinnaker.de>
 *
 *  This program is free software; you can redistribute
 *  it and/or modify it under the terms of the GNU
 *  General Public License as published by the Free
 *  Software Foundation; either version 2 of the License,
 *  or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will
 *  be useful, but WITHOUT ANY WARRANTY; without even the
 *  implied warranty of MERCHANTABILITY or FITNESS FOR A
 *  PARTICULAR PURPOSE.  See the GNU General Public
 *  License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, see <https://www.gnu.org/licenses/>.
 *
 */

#include <stdio.h>

#include "helpers.h"
#include "rfc822.h"
#include "rfc2047.h"

int main (int argc, char * argv[])
{
  char buff[2048];
#ifdef HAVE_ICONV
  const char **charsetptr = &Charset;
#endif

#ifdef HAVE_ICONV
  if (argc > 1)
    *charsetptr = argv[1];
#endif

  while (fgets (buff, sizeof (buff), stdin)) {
    rfc2047_decode (buff, buff, sizeof (buff));
    fputs (buff, stdout);
  }
  
  return 0;
}

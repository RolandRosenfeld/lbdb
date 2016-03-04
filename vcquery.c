/*
 *     Copyright (C) 2005  Brendan Cully <brendan@kublai.com>
 *     Copyright (C) 2010  martin f krafft <madduck@debian.org>
 *     Copyright (C) 2011  Roland Rosenfeld <roland@spinnaker.de>
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
 *     You should have received a copy of the GNU General Public License
 *     along with this program; if not, write to the Free Software Foundation,
 *     Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301,, USA.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vf_iface.h>

#define STRING 256

typedef struct {
  char* filename;
} option_t;

int parse_opts(option_t* opts, int argc, char** argv);

int main(int argc, char** argv)
{
  option_t opts;
  VF_OBJECT_T*  vfobj;
  VF_PROP_T* prop;
  char* propval;
  char* fullname; /* TODO: initialise */
  char* nickname;

  if (parse_opts(&opts, argc, argv))
    return 1;

  if (!vf_read_file(&vfobj, opts.filename)) {
    fprintf(stderr, "Could not read VCF file %s\n", opts.filename);
    return 1;
  }

  do {
    fullname = 0;
    /* First extract name */
    if (vf_get_property(&prop, vfobj, VFGP_FIND, NULL, "FN", NULL))
      if ((fullname = vf_get_prop_value_string(prop, 0)))
	fullname = strdup(fullname);

    /* No full name, lets try name */
    if (!fullname 
	&& vf_get_property(&prop, vfobj, VFGP_FIND, NULL, "N", NULL)) {
      char name[STRING+1] = { 0 };
      size_t available = STRING;
      int props = 0;

      while (available > 0 
	     && (propval = vf_get_prop_value_string(prop, props++))) {
        strncat(name, propval, available);
        available -= strlen(propval);

        if (available > 0)
          strncat(name, " ", available--);
      }

      if (available < STRING)
        fullname = strdup(name);
    }
    /* TODO: fullname may actually still be NULL! */

    nickname = NULL;
    if (vf_get_property(&prop, vfobj, VFGP_FIND, NULL, "NICKNAME", NULL)) {
      propval = vf_get_prop_value_string(prop, 0);
      if (propval)
        nickname = strdup(propval);
    }

    if (vf_get_property(&prop, vfobj, VFGP_FIND, NULL, "EMAIL", NULL)) {
      do {
	int props = 0;

	while ((propval = vf_get_prop_value_string(prop, props++))) {
	  printf("%s\t%s", propval, fullname);
	  if (nickname) {
	    printf("\t%s", nickname);
	  } else {
	    putchar('\t');
	  }
	  putchar('\n');
	}
      } while (vf_get_next_property(&prop));
    }

    if (fullname)
      free(fullname);
    if (nickname)
      free(nickname);

  } while (vf_get_next_object(&vfobj));

  return 0;
}

int parse_opts(option_t* opts, int argc, char** argv)
{
  if (argc < 2) {
    fprintf(stderr, "File name required\n");
    return -1;
  }

  opts->filename = strdup(argv[1]);

  return 0;
}

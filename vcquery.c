/*
 *     Copyright (C) 2005  Brendan Cully <brendan@kublai.com>
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
 * $Id$
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
  char* fullname;

  if (parse_opts(&opts, argc, argv))
    return 1;

  if (!vf_read_file(&vfobj, opts.filename)) {
    fprintf(stderr, "Could not read VCF file %s\n", opts.filename);
    return 1;
  }

  while (vf_get_next_object(&vfobj)) {
    fullname = 0;
    /* First extract name */
    if (vf_get_property(&prop, vfobj, VFGP_FIND, NULL, "FN", NULL))
      if ((fullname = vf_get_prop_value_string(prop, 0)))
	fullname = strdup(fullname);

    if (vf_get_property(&prop, vfobj, VFGP_FIND, NULL, "EMAIL", NULL)) {
      do {
	int props = 0;

	while ((propval = vf_get_prop_value_string(prop, props++)))
	  printf("%s\t%s\n", propval, fullname);
      } while (vf_get_next_property(&prop));
    }

    if (fullname)
      free(fullname);
  }

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

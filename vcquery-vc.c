/*
 *     Copyright (C) 2005  Brendan Cully <brendan@kublai.com>
 *     Copyright (C) 2010  martin f krafft <madduck@debian.org>
 *     Copyright (C) 2011-2024  Roland Rosenfeld <roland@spinnaker.de>
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
#include <vc.h>

#define STRING 256

typedef struct {
    char *filename;
} option_t;

int parse_opts(option_t *opts, int argc, char **argv);

int main(int argc, char **argv)
{
    option_t opts;
    vc_component *vcobj;
    vc_component *prop;
    char *propval;
    char *fullname = NULL;
    char *nickname = NULL;

    const unsigned int namemap[5] = { 3, 1, 2, 0, 4 };
    /* RFC 2426 defines N: field with 5 components:
     * Family Name (3), Given Name (1), Additional Names (2),
     * Honorific Prefixes (0), Honorific Suffixes (4)
     */

    if (parse_opts(&opts, argc, argv)) {
        return 1;
    }

    FILE *fp = fopen(opts.filename, "r");
    if (!fp) {
        fprintf(stderr, "Could not read VCF file %s\n", opts.filename);
        return 1;
    }

    for (vcobj = parse_vcard_file(fp); NULL != vcobj;
         vcobj = parse_vcard_file(fp)) {
        fullname = NULL;
        /* First extract name */
        prop = vc_get_next_by_name(vcobj, VC_FORMATTED_NAME);
        if (prop) {
            if ((propval = vc_get_value(prop))) {
                fullname = strdup(propval);
            }
        }

        /* No full name, lets try name */
        if (!fullname
            && ((prop = vc_get_next_by_name(vcobj, VC_NAME)))) {
            char name[STRING + 1] = { 0 };
            size_t available = STRING;
            int props = 0;

            while (available > 0 && props < 5) {
                if ((propval =
                     get_val_struct_part(vc_get_value(prop),
                                         namemap[props++]))) {
                    strncat(name, propval, available);
                    available -= strlen(propval);

                    if (available > 0) {
                        strncat(name, " ", available--);
                    }
                }
            }

            if (available < STRING) {
                fullname = strdup(name);
            }
        }
        /* TODO: fullname may actually still be NULL! */

        nickname = NULL;
        if ((prop = vc_get_next_by_name(vcobj, VC_NICKNAME))) {
            propval = vc_get_value(prop);
            if (propval) {
                nickname = strdup(propval);
            }
        }

        prop = vc_get_next_by_name(vcobj, VC_EMAIL);
        while (prop != NULL) {
            propval = vc_get_value(prop);
            printf("%s\t%s", propval, fullname);
            if (nickname) {
                printf("\t%s", nickname);
            } else {
                putchar('\t');
            }
            putchar('\n');
            prop = vc_get_next_by_name(prop, VC_EMAIL);
        }
        vc_delete_deep(vcobj);
        vcobj = NULL;
        if (fullname) {
            free(fullname);
        }
        if (nickname) {
            free(nickname);
        }
    }

    vc_delete(vcobj);

    return 0;
}

int parse_opts(option_t *opts, int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "File name required\n");
        return -1;
    }

    opts->filename = strdup(argv[1]);

    return 0;
}

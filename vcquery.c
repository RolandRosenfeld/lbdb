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

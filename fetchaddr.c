/*
 *  Copyright (C) 1998  Thomas Roessler <roessler@guug.de>
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
 *  You should have received a copy of the GNU General
 *  Public License along with this program; if not, write
 *  to the Free Software Foundation, Inc., 675 Mass Ave,
 *  Cambridge, MA 02139, USA.
 *
 */

/* $Id$ */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "helpers.h"
#include "rfc822.h"
#include "rfc2047.h"

struct header
{
  const char *tag;
  char *value;
  size_t len;
  size_t taglen;
};

struct header hdr[] =
{
  { "to:",		NULL, 0,  3 },
  { "from:",		NULL, 0,  5 },
  { "cc:",		NULL, 0,  3 },
  { "resent-from:",	NULL, 0, 12 },
  { "resent-to:",	NULL, 0, 10 },
  { NULL, 		NULL, 0,  0 }
};

void chop(struct header *cur)
{
  if(cur->len && cur->value[cur->len - 1] == '\n')
    cur->value[--cur->len] = '\0';
}

int writeout(struct header *h)
{
  int rv = 0;
  ADDRESS *addr, *p;
  time_t timep;
  char timebuf[16];
  char *c;

  if(!h->value)
    return 0;
  
  addr = rfc822_parse_adrlist(NULL, h->value);
  time(&timep);

  rfc2047_decode_adrlist(addr);
  for(p = addr; p; p = p->next)
  {
    if(!p->group && p->mailbox && *p->mailbox && p->personal)
    {
      if(p->personal && strlen(p->personal) > 30)
	strcpy(p->personal + 27, "...");

      if ((c=strchr(p->mailbox,'@')))
	for(c++; *c; c++)
	  *c=tolower(*c);

#if 0
      printf("%s\t%s\t%s", p->mailbox, p->personal && *p->personal ? 
	     p->personal : "no realname given",
	     ctime(&timep));
#else
      strftime(timebuf, sizeof(timebuf), "%y-%m-%d %H:%M", localtime(&timep));
      printf("%s\t%s\t%s\n", p->mailbox, p->personal && *p->personal ? 
	     p->personal : "no realname given", timebuf);
#endif
      rv = 1;
    }
  }

  rfc822_free_address(&addr);

  return rv;
}
  
int main()
{
  char buff[2048];
  char *t;
  int i, rv;
  int partial = 0;
  struct header *cur_hdr = NULL;

  while(fgets(buff, sizeof(buff), stdin))
  {
    
    if(!partial && *buff == '\n')
      break;

    if(cur_hdr && (partial || *buff == ' ' || *buff == '\t'))
    {
      size_t nl = cur_hdr->len + strlen(buff);
      
      safe_realloc((void **) &cur_hdr->value, nl + 1);
      strcpy(cur_hdr->value + cur_hdr->len, buff);
      cur_hdr->len = nl;
      chop(cur_hdr);
    }
    else if(!partial && *buff != ' ' && *buff != '\t')
    {
      cur_hdr = NULL;

      for(i = 0; hdr[i].tag; i++)
      {
	if(!strncasecmp(buff, hdr[i].tag, hdr[i].taglen))
	{
	  cur_hdr = &hdr[i];
	  break;
	}
      }
      
      if(cur_hdr)
      {
	safe_free((void **) &cur_hdr->value);
	cur_hdr->value = safe_strdup(buff + cur_hdr->taglen);
	cur_hdr->len = strlen(cur_hdr->value);
	chop(cur_hdr);
      }
    }
    
    if(!(t = strchr(buff, '\n')))
      partial = 1;
    else
      partial = 0;
  }

  for(rv = 0, i = 0; hdr[i].tag; i++)
  {
    if(hdr[i].value)
      rv = writeout(&hdr[i]) || rv;
  }

  return (rv ? 0 : 1);
  
}

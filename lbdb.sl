%
% Query the little brother's database from within jed.
%
%     Copyright (C) 1998  Thomas Roessler <roessler@guug.de>
% 
%     This program is free software; you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation; either version 2 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program; if not, write to the Free Software
%     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

% $Id$

variable lbdb_buf = "*lbdb*";
variable num_win;
variable buf;
variable old_buf;

!if (keymap_p(lbdb_buf)) make_keymap(lbdb_buf);

definekey ("lbdb_select",	"\r",	lbdb_buf);
definekey ("lbdb_quit", 	"q", 	lbdb_buf);
definekey ("next_line_cmd",	"j",	lbdb_buf);
definekey ("previous_line_cmd",	"k",	lbdb_buf);

define lbdb_select_str()
{
  if(not(bolp())) 
    go_left_1();

  while(1)
  {
    if(looking_at_char(',')) break;
    if(looking_at_char(' ')) break;
    if(looking_at_char('\t')) break;
    if(bolp()) break;
    go_left_1();
  }

  if(looking_at_char(',') or looking_at_char(' ') or looking_at_char('\t'))
    go_right_1();
  push_mark();

  while(1)
  {
    if(looking_at_char(',')) break;
    if(looking_at_char(' ')) break;
    if(looking_at_char('\t')) break;    
    if(eolp()) break;
    go_right_1();
  }
}

define lbdb_quit()
{
  sw2buf(old_buf);
  pop2buf(buf);
  if(num_win == 1) onewindow();
  delbuf(lbdb_buf);
}


define lbdb_select()
{
  variable addr;
  
  bol();
  push_mark_eol();
  addr = bufsubstr();
  lbdb_quit();

  lbdb_select_str();
  del_region();
  insert(addr);
}

define lbdbq()
{
  variable query;
  variable file, flags;
  
  buf = whatbuf();
  
  push_spot();
  lbdb_select_str();
  query = bufsubstr();
  pop_spot();
  
  sw2buf(lbdb_buf);
  (file,,flags) = getbuf_info();
  setbuf_info(file, query, lbdb_buf, flags);
  set_readonly(0);
  erase_buffer();
  use_keymap(lbdb_buf);
  set_mode("lbdb");

  shell_cmd(Sprintf("lbdbq \"%s\" | awk -F '	' '{printf(\"%%s <%%s>\\\\n\", $2, $1);}' 2> err",
		    query, 1));
  bob();
  push_mark_eol();
  del_region(); del();

  set_buffer_modified_flag(0);
  set_readonly(1);

  num_win = nwindows();
  pop2buf(buf);
  old_buf = pop2buf_whatbuf(lbdb_buf);
  
  if(eobp())
  {
    message("No matches.");
    lbdb_quit();
    return;
  }

  eob(); go_up_1(); bol();
  if(bobp())
  {
    lbdb_select();
    return;
  }
  else
    bob();
}

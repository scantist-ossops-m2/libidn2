#!/usr/bin/perl -w

# Copyright (C) 2011 Simon Josefsson

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# I consider the output of this program to be unrestricted.  Use it as
# you will.

use strict;

my ($intable) = 0;
my ($filename) = "tables.c";
my ($line, $start, $end, $state);

open(FH, ">$filename") or die "cannot open $filename for writing";

print FH "/* This file is automatically generated.  DO NOT EDIT!\n";
print FH "   Instead, edit gen-tables.pl and re-run.  */\n\n";

print FH "#include <config.h>\n";
print FH "#include \"tables.h\"\n";
print FH "\n";
print FH "const struct idna_table idna_table\[\] = {\n";

while(<>) {
    $intable = 1 if m,^    Codepoint    Property,;
    next if !$intable;

    next if m,^    Codepoint    Property,;
    next if m,^ +PROSGEGRAMMENI$,;

    if (m, +([0-9A-F]+)(-([0-9A-F]+))? (PVALID|CONTEXTJ|CONTEXTO|DISALLOWED|UNASSIGNED) ,) {
	$start = $1;
	$end = $3;
	$state = $4;
	printf FH "  {0x$start, 0x$end, $state},\n" if $end;
	printf FH "  {0x$start, 0x0, $state},\n" if !$end;
    } else {
	die "regexp failed on line: -->$_<--";
    }
}

printf FH "  {0x0, 0x0}\n";
print FH "};\n";

close FH or die "cannot close $filename";

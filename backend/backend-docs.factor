! Copyright (C) 2007, 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: help.markup help.syntax io.launcher sequences math strings
       giplayer.backend.private ;
IN: giplayer.backend

HELP: run-and-read-process
{ $values { "process" process } { "output" "The UTF8 encoded output" } }
{ $description "Run the process specified and return the output (assumed UTF8). Throws an error if the process returns with a nonzero exit code." } ;

HELP: sos-test
{ $values { "seq" sequence } { "subseq" sequence } }
{ $description "If seq is not false, sets ? to t. If it find a match for subseq, it sets posn to be the start, otherwise sets posn to f." } ;

HELP: sos-prod
{ $description "If posn/f is f then tail is f and piece is seq. Otherwise, split as expected, with piece being the head of seq, up to posn/f and tail being the rest after posn/f + len" } ;

HELP: split-on-subseq
{ $values { "seq" sequence } { "subseq" sequence } { "pieces" sequence } } 
{ $description "Split a sequence by matching occurrences of a subsequence." }
{ $examples
  { $example
    "USING: giplayer.backend ;"
    "\"test@@me\" \"@@\" split-on-subseq"
    "{ \"test\" \"me\" }"
  }
} ;

HELP: force-string>int
{ $values { "input" string } { "noun" string } { "int" integer } }
{ $description "Convert a string to an integer. If we fail, throw a " { $link list-parse-error } ", complaining that the given string can't be converted to such a noun." } ;

USING: help.markup help.syntax models models.arrow ;
IN: giplayer.marrow

ARTICLE: { "giplayer.marrow" "marrow" } "marrow: the Maybe Arrow"
"In some cases, one wants a " { $link model } " like an " { $link arrow } ", but where there's a possibly slow calculation required some of the time. If this can be farmed out to a separate process, a marrow can be used to express the situation with a model."
$nl
"Use the " { $link <marrow> } " command to create one, passing the 'quick update' code (as transform) and the 'slow update' code as refresh. If transform returns " { $link f } " then the model will get set to have value " { $link f } " and a new thread will be spawned to run " { $snippet "refresh" } ". Once the calculation completes, the model will get updated with the new value."
$nl
{ $notes
  "There's no cacheing done of the result calculated by refresh, so if you want that, you need to do it yourself." } ;

ABOUT: { "giplayer.marrow" "marrow" }

HELP: marrow
{ $class-description
  "A 'maybe arrow'. The new slot is "
  { $snippet "refresh" } ": " { $quotation "( x -- y )" } " where " { $snippet "x" } " is the input from the previous model and " { $snippet "y" } " is the (possibly slow to compute) output value."
  $nl
  "Note that the meaning of the slot " { $snippet "quot" } " has changed slightly from in it's parent class, " { $link arrow } ": see " { $link { "giplayer.marrow" "marrow" } } " for more details."
} ;


HELP: <marrow>
{ $values
  { "model" model }
  { "transform" { $quotation "( input -- output? )" } }
  { "refresh" { $quotation "( input -- output )" } }
  { "marrow" marrow }
} ;

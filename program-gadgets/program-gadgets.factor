USING: kernel accessors sequences arrays math math.bitwise
       giplayer.listings math.parser math.order
       models ui ui.gadgets ui.gadgets.packs ui.gadgets.labels
       ui.gadgets.panes ui.gadgets.borders ui.gadgets.scrollers
       ui.pens.solid io.styles io locals colors fonts calendar.format ;

IN: giplayer.program-gadgets

TUPLE: programme-list < pack ;

: <noprogrammes-gadget> ( -- gadget )
    "No programmes found" <label> ;

: <programme-list> ( listing-model -- gadget )
    programme-list new
        swap >>model
        1 >>fill
        { 0 10 } >>gap
    <noprogrammes-gadget> add-gadget
    <scroller> ;

: kth-page ( pagelen k seq -- subseq )
    3dup [ * ] [ length ] bi* <
    [
        [ [ * ] [ 1 + * ] 2bi ] dip [ length ] keep
        [ min ] dip subseq
    ] [ 3drop { } clone ] if ;

! Hash the station name to a 32 bit integer, then take 21 bits to get
! 3 numbers 0-128. Now add 128 to each (and divide to put into [0,1]).
: programme-colour ( l -- colour )
    channel>> reverse hashcode
    { HEX: 7f HEX: 3fff HEX: 1fffff } [ mask ] with map
    { 0 -7 -14 } [ shift 128 + 256 /f ] 2map
    first3 1 <rgba> ;

: output-categories ( l -- )
    { { wrap-margin 500 } { inset { 10 0 } } } swap
    categories>> [    
        [
            "\n" append { { font-size 12 } } format
        ] each
    ] curry with-nesting ;

:: output-programme ( l -- )
    { { wrap-margin 500 } { inset { 5 0 } } }
    [
        l name>> { { font-size 17 } } format
        l channel>> " (from " ")" surround
        { { font-size 15 } } format
    ] with-nesting
    nl
    { { wrap-margin 500 } { inset { 10 0 } } }
    [
        l episode>> { { font-size 15 } } format
        nl
        "Added: " l timeadded>> file-time-string append
        { { font-size 15 } } format
    ] with-nesting
    nl
    { { wrap-margin 500 } { inset { 20 6 } } }
    [ l description>> { { font-size 14 } } format ] with-nesting
    nl
    l output-categories ;

: <program-gadget> ( listing -- gadget )
    dup [ output-programme ] make-pane
        swap programme-colour <solid> >>interior ;

: pl-child-gadgets ( model -- gadgets )
    value>> dup empty?
    [ drop <noprogrammes-gadget> 1array ]
    [ [ 10 0 ] dip kth-page [ <program-gadget> ] map ] if ;

M: programme-list model-changed
    [ clear-gadget ] keep swap pl-child-gadgets add-gadgets drop ;

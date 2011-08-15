USING: kernel accessors sequences formatting
       giplayer.backend giplayer.listings giplayer.program-gadgets
       giplayer.search-box
       ui ui.gadgets ui.gadgets.packs ui.gadgets.labels
       ui.gadgets.frames ui.gadgets.grids ui.gadgets.borders
       ui.gadgets.buttons fonts
       models models.arrow ;

IN: giplayer

CONSTANT: default-program-type "radio"

CONSTANT: program-types { { "radio" "Radio" }
                          { "liveradio" "Live Radio" }
                          { "tv" "TV" }
                          { "livetv" "Live TV" } }

: <title-label> ( -- gadget )
    "Get-iPlayer Frontend" <label>
        sans-serif-font 20 >>size >>font
    { 5 5 } <border> ;
    
: <types-buttons> ( -- gadget types-model )
    default-program-type <model>
    dup program-types <radio-buttons>
        horizontal >>orientation
        { 15 0 } >>gap
        0.5 >>align
    { 10 0 } <border>
    swap ;

: seq-to-count-str ( seq noun -- str )
    [ length ] dip over 1 = [ "" ] [ "s" ] if "%d %s%s found" sprintf ;

: <count-pane> ( listings-model -- gadget )
    [ "programme" seq-to-count-str ] <arrow> <label-control> ;

TUPLE: top-bar < pack ;

: <top-bar> ( -- gadget search-model )
    top-bar new
        vertical >>orientation
        1 >>fill
    3 1 <frame>
        { 1 0 } >>filled-cell
    <title-label> { 0 0 } grid-add
    <types-buttons> [ { 2 0 } grid-add add-gadget ] dip
    <listings-model> <search-box> [ add-gadget ] dip
    [
        <count-pane> { 10 5 } <border>
        2 1 <frame> { 0 0 } >>filled-cell swap { 1 0 } grid-add
        add-gadget
    ] keep ;

: frame-layout ( -- frame )
    1 2 <frame>
        { 0 1 } >>filled-cell
    <top-bar> [ { 0 0 } grid-add ] dip
    <programme-list> { 0 1 } grid-add ;
    
MAIN-WINDOW: giplayer-window { { title "Get-iPlayer Frontend" } }
    frame-layout >>gadgets ;

USING: kernel accessors sequences
       giplayer.backend giplayer.listings
       ui ui.gadgets ui.gadgets.packs ui.gadgets.labels
       ui.gadgets.editors ui.gadgets.buttons fonts
       models models.arrow math.parser ;

IN: giplayer

CONSTANT: default-program-type "radio"

CONSTANT: program-types { { "radio" "Radio" }
                          { "liveradio" "Live Radio" }
                          { "tv" "TV" }
                          { "livetv" "Live TV" } }

: search-programs ( string -- )
    drop ;

: <title-label> ( -- gadget )
    "Get-iPlayer Frontend" <label>
        sans-serif-font 20 >>size >>font ;

: <types-buttons> ( -- gadget model )
    default-program-type <model>
    dup program-types <radio-buttons> swap ;

: <search-box> ( -- gadget )
    <shelf>
    "Search for program: " <label> add-gadget
    [ search-programs ] <action-field> 25 >>min-cols add-gadget ;

: <top-pane> ( -- gadget radio-model )
    <shelf>
    <pile> <title-label> add-gadget <search-box> add-gadget add-gadget
    <types-buttons> [ add-gadget ] dip ;

: <listings-pane> ( radio-model -- gadget )
    <listings-model> [ length number>string ] <arrow> <label-control> ;

: <gip-gadget> ( -- gadget )
    <pile> <top-pane> [ add-gadget ] dip <listings-pane> add-gadget ;
    
MAIN-WINDOW: giplayer-window { { title "Gnome iPlayer" } }
    <gip-gadget> >>gadgets ;

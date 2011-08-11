USING: kernel accessors
       giplayer.backend
       ui ui.gadgets ui.gadgets.packs ui.gadgets.labels
       ui.gadgets.editors ui.gadgets.buttons fonts
       models ;

IN: giplayer

CONSTANT: default-program-type "radio"

CONSTANT: program-types { { "radio" "Radio" }
                          { "liveradio" "Live Radio" }
                          { "tv" "TV" }
                          { "livetv" "Live TV" } }

: search-programs ( string -- )
    drop ;

: refresh-listings ( button -- )
    drop ;

: <title-label> ( -- gadget )
    "Get-iPlayer Frontend" <label>
        sans-serif-font 20 >>size >>font ;

: <types-buttons> ( -- gadget )
    default-program-type <model> program-types <radio-buttons> ;

: <search-box> ( -- gadget )
    <shelf>
    "Search for program: " <label> add-gadget
    [ search-programs ] <action-field> 25 >>min-cols add-gadget ;

: <top-pane> ( -- gadget )
    <shelf>
    <pile> <title-label> add-gadget <search-box> add-gadget add-gadget
    <types-buttons> add-gadget ;

: <refresh-button-pane> ( -- gadget )
    "Refresh iPlayer Listings" [ refresh-listings ] <border-button> ;

: <gip-gadget> ( -- gadget )
    <pile> <top-pane> add-gadget <refresh-button-pane> add-gadget ;
    
MAIN-WINDOW: giplayer-window { { title "Gnome iPlayer" } }
    <gip-gadget> >>gadgets ;

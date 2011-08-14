USING: kernel accessors sequences formatting
       giplayer.backend giplayer.listings giplayer.program-gadgets
       giplayer.search-box
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

: <types-buttons> ( -- gadget types-model )
    default-program-type <model>
    dup program-types <radio-buttons> swap ;

: top-stuff ( -- left-pile types-buttons search-model )
    <types-buttons> <listings-model> <search-box>
    [
        <pile> <title-label> add-gadget swap add-gadget swap
    ] dip ;

: <top-pane> ( -- gadget search-model )
    <shelf> top-stuff [ [ add-gadget ] dip add-gadget ] dip ;

: seq-to-count-str ( seq noun -- str )
    [ length ] dip over 1 = [ "" ] [ "s" ] if "%d %s%s found" sprintf ;

: <count-pane> ( listings-model -- gadget )
    [ "programme" seq-to-count-str ] <arrow> <label-control> ;

: <listings-pane> ( listings-model -- gadget )
    <programme-list> ;

: <gip-gadget> ( -- gadget )
    <pile>
        1 >>fill
    <top-pane> [ add-gadget ] dip
    [ <count-pane> add-gadget ] keep
    <listings-pane> add-gadget ;
    
MAIN-WINDOW: giplayer-window { { title "Gnome iPlayer" } }
    <gip-gadget> >>gadgets ;

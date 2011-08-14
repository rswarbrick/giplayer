USING: kernel accessors sequences formatting
       giplayer.backend giplayer.listings giplayer.program-gadgets
       giplayer.search-box
       ui ui.gadgets ui.gadgets.packs ui.gadgets.labels
       ui.gadgets.frames ui.gadgets.grids
       ui.gadgets.editors ui.gadgets.buttons fonts
       models models.arrow math.parser ;

IN: giplayer

CONSTANT: default-program-type "radio"

CONSTANT: program-types { { "radio" "Radio" }
                          { "liveradio" "Live Radio" }
                          { "tv" "TV" }
                          { "livetv" "Live TV" } }

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

TUPLE: top-bar < pack ;

: <top-bar> ( -- gadget search-model )
    top-bar new
        horizontal >>orientation
    top-stuff [ [ add-gadget ] dip add-gadget ] dip ;

: seq-to-count-str ( seq noun -- str )
    [ length ] dip over 1 = [ "" ] [ "s" ] if "%d %s%s found" sprintf ;

: <count-pane> ( listings-model -- gadget )
    [ "programme" seq-to-count-str ] <arrow> <label-control> ;

: <listings-pane> ( listings-model -- gadget )
    <programme-list> ;

: frame-layout ( -- frame )
    1 3 <frame>
        { 0 2 } >>filled-cell
    <top-bar> [ { 0 0 } grid-add ] dip
    [ <count-pane> { 0 1 } grid-add ] keep
    <listings-pane> { 0 2 } grid-add ;
    
MAIN-WINDOW: giplayer-window { { title "Gnome iPlayer" } }
    frame-layout >>gadgets ;

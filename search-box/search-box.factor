IN: giplayer.search-box
USING: giplayer.backend models models.arrow accessors kernel sequences
       assocs ui.gadgets.packs ui.gadgets.editors ui.gadgets
       ui.gadgets.labels ;

TUPLE: filter-model < arrow filters ;

GENERIC: set-filter ( quot key fmodel -- fmodel )
GENERIC: delete-filter ( key fmodel -- )

: new-filter-model ( model class -- model' )
    [ dup value>> ] dip new-model
        V{ } clone >>filters
    [ add-dependency ] keep ;

: <filter-model> ( model -- model' )
    filter-model new-filter-model ;

: combined-filter-fails? ( elt filters -- ? )
    [ second call( x -- ? ) not ] with find drop ;

: combined-filter ( seq filters -- subseq )
    [ combined-filter-fails? not ] curry filter ;

M: filter-model model-changed
    [ [ value>> ] [ filters>> ] bi* combined-filter ] 2keep
    nip set-model ;

M: filter-model set-filter
    [ filters>> set-at ] keep [ model-activated ] keep ;
    
M: filter-model delete-filter
    filters>> delete-at ;

TUPLE: search-model < filter-model ;

: <search-model> ( model -- model' )
    search-model new-filter-model ;

: make-text-search ( str -- quot )
    [ swap start ] curry
    [ [ name>> ] [ description>> ] bi append ] prepose ;

: add-text-search ( search-model string -- search-model )
    [ make-text-search ] keep rot set-filter ;

: delete-text-search ( string search-model -- )
    delete-filter ;

TUPLE: search-box < pack ;

: make-search-action-field ( listing-model -- gadget search-model )
    <search-model> [
        [ swap add-text-search drop ] curry
        <action-field> 25 >>min-cols
    ] keep ;

: <search-box> ( listing-model -- gadget search-model )
    search-box new
        horizontal >>orientation
    "Search for program: " <label> add-gadget
    swap make-search-action-field [ add-gadget ] dip ;

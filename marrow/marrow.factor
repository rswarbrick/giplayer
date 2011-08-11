IN: giplayer.marrow
USING: kernel threads models models.arrow accessors ;

TUPLE: marrow < arrow refresh ;

: <marrow> ( model transform refresh -- marrow )
    f marrow new-model
        swap >>refresh
        swap >>quot
    [ add-dependency ] keep ;

<PRIVATE

: [marrow-updater] ( input-value marrow -- quot )
    [ [ value>> ] [ refresh>> curry ] bi* ] keep
    [ set-model ] curry compose ;

M: marrow model-changed
    2dup [ value>> ] [ quot>> ] bi* call( old -- new? )
    [ 2dup [marrow-updater] "marrow-refresh" spawn drop f ] unless*
    swap set-model drop ;

PRIVATE>

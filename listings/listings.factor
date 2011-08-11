! The listings database.
IN: giplayer.listings
USING: kernel assocs concurrency.locks values threads
       giplayer.backend ;

VALUE: listings-db
V{ } clone to: listings-db

VALUE: listings-lock
<lock> to: listings-lock

: with-listings-lock ( quot -- )
    [ listings-lock ] dip with-lock ; inline

: set-listings-db ( contents type -- )
    [ listings-db set-at ] with-listings-lock ;

: refresh-listing ( type -- )
    [ [ iplayer-listings ] keep set-listings-db ] curry
    "refresh-listing" spawn drop ;

: get-listings ( type -- listings/f )
    [ dup listings-db at [ nip ] [ refresh-listing f ] if* ]
    with-listings-lock ;

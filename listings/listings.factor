! The listings database.
IN: giplayer.listings
USING: kernel assocs concurrency.locks values threads
       giplayer.backend ;

! Todo: We should make sure that we don't refresh the same listing
! twice. Maybe keep a list of "things to refresh" and make
! get-listings push names onto it?

<PRIVATE

VALUE: listings-db
V{ } clone to: listings-db

VALUE: listings-lock
<lock> to: listings-lock

PRIVATE>

: with-listings-lock ( quot -- )
    [ listings-lock ] dip with-lock ; inline

<PRIVATE

: set-listings-db ( contents type -- )
    [ listings-db set-at ] with-listings-lock ;

PRIVATE>

: refresh-listing ( type -- )
    [ [ iplayer-listings ] keep set-listings-db ] curry
    "refresh-listing" spawn drop ;

: get-listings ( type -- listings/f )
    [ dup listings-db at [ nip ] [ refresh-listing f ] if* ]
    with-listings-lock ;

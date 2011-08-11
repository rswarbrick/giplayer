! The listings database.
IN: giplayer.listings
USING: kernel assocs concurrency.locks values threads sequences
       combinators combinators.short-circuit
       giplayer.marrow giplayer.backend ;

! This should implement a model, which is the list of programmes of a
! given type (before any sort of search filtering). The idea is that
! we call <listings-model>, which takes the model from the radio
! boxes. Then when the type changes, we try to update our model.
!
! There are two possibilities. If we have listings, then we can just
! use them.If not, call refresh-listing in a new thread and then
! alter the model when we're done: this is abstracted with marrow.

<PRIVATE

VALUE: listings-db
V{ } clone to: listings-db

VALUE: retrieving
V{ } clone to: retrieving

VALUE: listings-lock
<lock> to: listings-lock

PRIVATE>

: with-listings-lock ( quot -- )
    [ listings-lock ] dip with-lock ; inline

: peek-listings ( type -- listings? )
    [ listings-db at ] with-listings-lock ;

<PRIVATE

: set-listings-db ( contents type -- )
    [ [ listings-db set-at ] keep retrieving remove! drop ]
    with-listings-lock ;

! The caller should have pushed TYPE onto RETRIEVING before calling us
! (we can't do it here with symmetric locking without a race
! condition). SET-LISTINGS-DB removes it again.
: really-fetch-listings ( type -- listings )
    dup iplayer-listings [ swap set-listings-db ] keep ;

: maybe-fetch-listings ( type -- listings? )
    [
        dup
        { [ listings-db at ] [ retrieving swap index t and ] } 1||
        [ dup retrieving push f ] unless*
    ] with-listings-lock
    {
        { [ dup not ] [ drop really-fetch-listings ] }
        { [ dup t = ] [ 2drop f ] }
        [ nip ]
    } cond ;

PRIVATE>

: get-listings ( type -- listings )
    [ dup maybe-fetch-listings dup ] [ drop 0.1 sleep ] until nip ;

: <listings-model> ( radio-model -- listings-model )
    [ peek-listings ] [ get-listings ] <marrow> ;

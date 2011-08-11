USING: kernel arrays accessors sequences values namespaces
       continuations concurrency.locks math splitting
       formatting calendar
       combinators.short-circuit math.parser
       io io.launcher io.encodings.utf8 ;

IN: giplayer.backend

<PRIVATE

CONSTANT: get-iplayer-fields
{ "index" "name" "episode" "desc" "available" "duration" "versions"
  "thumbnail" "channel" "categories" "type" "timeadded" }
CONSTANT: gip-separator "@GIP@"
CONSTANT: get-iplayer-command "get-iplayer"

PRIVATE>

ERROR: get-iplayer-error arguments exit-status ;
ERROR: list-parse-error complaint ;

TUPLE: listing index name episode description available duration
               versions thumbnail channel categories type timeadded ;

<PRIVATE

: run-and-read-process ( process -- output )
    utf8 [ input-stream get stream-contents ] with-process-reader ;

: sos-test ( seq subseq -- seq posn ? )
    [ over start ] [ drop ] 2bi ;

: sos-prod ( seq posn/f len -- tail piece )
    over [ [ + tail ] 3keep drop head ] [ drop swap ] if ;

: split-on-subseq ( seq subseq -- pieces )
    [ [ sos-test ] curry ] [ length [ sos-prod ] curry ] bi
    produce 2nip ;

: force-string>int ( input noun -- int )
    over string>number dup integer? [ 2nip ]
    [ [ "'%s' is not a valid %s" sprintf list-parse-error ] dip ] if ;

: parse-index ( str -- n )
    "index" force-string>int ;

: parse-categories ( str -- seq )
    "," split dup { "" } = [ drop { } ] when ;

: parse-timeadded ( str -- timestamp )
    "time added" force-string>int seconds since-1970 ;

: <listing> ( fields -- listing )
    dup length 12 =
    [ "<listing> expects 12 args" list-parse-error ] unless
    listing new
        [ unclip parse-index ] dip swap >>index
        [ unclip ] dip swap >>name
        [ unclip ] dip swap >>episode
        [ unclip ] dip swap >>description
        [ unclip ] dip swap >>available
        [ unclip ] dip swap >>duration
        [ unclip ] dip swap >>versions
        [ unclip ] dip swap >>thumbnail
        [ unclip ] dip swap >>channel
        [ unclip parse-categories ] dip swap >>categories
        [ unclip ] dip swap >>type
        [ unclip parse-timeadded ] dip swap >>timeadded
    nip ;

! There will be one worker thread, which is responsible for calling
! the get-iplayer executable with the relevant options or reading
! its data. The idea is that this will serialise all access to
! get-iplayer's state so it doesn't get accidentally buggered up. The
! following functions run in the worker thread.

VALUE: gi-lock
<lock> to: gi-lock

PRIVATE>

: with-gi-lock ( ..a quot: ( ..a -- ..b ) -- ..b )
    [ gi-lock ] dip with-lock ; inline

<PRIVATE

: run-get-iplayer-unsafe ( arguments -- output )
    [ get-iplayer-command prefix run-and-read-process ]
    [ code>> get-iplayer-error f ] recover ;

PRIVATE>

: run-get-iplayer ( arguments -- output )
    [ run-get-iplayer-unsafe ] curry with-gi-lock ;

<PRIVATE

: get-iplayer-listformat ( -- args )
    get-iplayer-fields [ "<" ">" surround ] map gip-separator join
    "--listformat" swap 2array ;

: gi-listingstart ( text -- start )
    [ "Matches:" ] dip start
    dup [ "Can't find start of matches" list-parse-error ] unless
    9 + ;

! On the n+1'st line should be "INFO: n Matching Programmes".
: gi-listings-info-count ( lines -- n )
    [ { [ length 7 > ] [ 6 head "INFO: " = ] } 1&& ] find
    dup [ "Can't find INFO: line" list-parse-error ] unless
    6 tail-slice " " split1 drop string>number
    dup [ "Can't understand INFO: line" list-parse-error ] unless
    2dup 1 + =
    [ "INFO: line has wrong position" list-parse-error ] unless nip ;

: gi-listinglines ( text -- seq )
    dup gi-listingstart tail string-lines
    dup gi-listings-info-count head ;

: gi-parse-listingline ( text -- listing )
    gip-separator split-on-subseq <listing> ;

PRIVATE>

: iplayer-listings ( type -- listings )
    "--type" swap 2array get-iplayer-listformat append
    run-get-iplayer gi-listinglines [ gi-parse-listingline ] map ;

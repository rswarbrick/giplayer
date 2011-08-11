USING: math giplayer.marrow models kernel tools.test accessors threads ;
IN: giplayer.marrow.tests

: test-marrow ( -- two )
    1 <model>
    [ drop f ] [ 1 + ] <marrow>
    [ activate-model ] keep
    [ value>> [ f assert ] when* ] keep
    yield
    [ deactivate-model ] keep
    value>> ;

! This shouldn't fail in the asserts above...
{ 2 } [ test-marrow ] unit-test

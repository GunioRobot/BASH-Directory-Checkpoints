mkdir -p ~/.ck

function ck {
    local CK='default'
    if [ $1 ]; then CK=$1; fi
    echo "checkpoint ($CK) = $PWD"
    echo $PWD > ~/.ck/$CK
}

function gock {
    local CK='default'
    if [ $1 ]; then CK=$1; fi

    local FNAME=~/.ck/$CK
    if [ ! -e $FNAME ]; then
        echo $CK does not exist
        return
    fi

    local CKPOINT=`cat ~/.ck/$CK`

    if [ $CKPOINT != $PWD ]; then
        ck bounce
        cd $CKPOINT
        echo "Currently in $PWD"
    else
        echo "Currently in $PWD"
    fi
}

function ckck {
    for tag in $( ls ~/.ck ); do
        echo "$tag = `cat ~/.ck/$tag`"
    done
}

function delck {
    if [ $1 ]; then
        rm -f ~/.ck/$1
    fi
}

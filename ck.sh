export CKDIR=${CKDIR-~/.ck}
mkdir -p $CKDIR

function ck {
    local TAG=${1-default}
    echo "Checkpoint ($TAG) = $PWD"
    echo $PWD > $CKDIR/$TAG

    return 0
}

function gock {
    local TAG=${1-default}
    local FILE_NAME=$CKDIR/$TAG

    if [ ! -e $FILE_NAME ]; then
        echo $TAG does not exist
        return 1
    fi

    local TO_DIR=`cat $FILE_NAME`
    if [ $TO_DIR != $PWD ]; then
        ck bounce
        cd $TO_DIR
        echo "Currently in $PWD"
    else
        echo "Currently in $PWD"
    fi

    return 0
}

function ckck {
    (
    printf "Matching checkpoints:\n"
    shopt -s nullglob # Executes in a subshell because of this
    for tag in $CKDIR/*$1*; do
        printf "%-20s = %s\n" `basename $tag` `cat $tag`
    done
    return 0
    )
}

function delck {
    local TAG=$1
    if [ $TAG ]; then
        rm -f $CKDIR/$TAG
        return 0
    else
        echo delck requires a tag to delete
        return 1
    fi
}

function ..to() {
    local ORIGDIR=$PWD
    local OLDDIR=$PWD
    local TARGET=$1
    while [ 1 ]
    do
        OLDDIR=$PWD
        cd ..
        if [ `basename $PWD` == $TARGET ]; then
            echo "Currently in $PWD"
            return 0
        elif [ $OLDDIR == $PWD ]; then
            cd $ORIGDIR
            echo "Unable to find parent directory '$TARGET' in $PWD"
            return 1
        fi
    done
}

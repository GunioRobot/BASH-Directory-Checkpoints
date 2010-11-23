mkdir -p ~/.ck

function ck {
    local TAG=${1-default}
    echo "Checkpoint ($TAG) = $PWD"
    echo $PWD > ~/.ck/$TAG
}

function gock {
    local TAG=${1-default}
    local FILE_NAME=~/.ck/$TAG

    if [ ! -e $FILE_NAME ]; then
        echo $TAG does not exist
        return
    fi

    local TO_DIR=`cat $FILE_NAME`
    if [ $TO_DIR != $PWD ]; then
        ck bounce
        cd $TO_DIR
        echo "Currently in $PWD"
    else
        echo "Currently in $PWD"
    fi
}

function ckck {
    (
    shopt -s nullglob # Executes in a subshell because of this
    for tag in ~/.ck/*$1*; do
        printf "%-20s = %s\n" `basename $tag` `cat $tag`
    done
    )
}

function delck {
    local TAG=$1
    if [ $TAG ]; then
        rm -f ~/.ck/$TAG
    else
        echo delck requires a tag to delete
    fi
}

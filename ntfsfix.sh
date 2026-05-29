#!/bin/bash

protoninstall()
{
    cd "${HOME}"/.steam/steam/steamapps/compatdata/ || exit 1
    mkdir -p $2
    cd /run/media/$(whoami)/$1/SteamLibrary/steamapps/compatdata/ || exit 1
    rm -r $2 || exit 1
    ln -s "${HOME}"/.steam/steam/steamapps/compatdata/$2 /run/media/$(whoami)/$1/SteamLibrary/steamapps/compatdata/
    cd 
}

usage()
{
    echo "Usage: ./$0 MEDIANAME STEAMID"
    echo "MEDIANAME: The name you see in your file browser, or here:"
    ls -1 /run/media/$(whoami)
    echo "---"
    echo "STEAMID: Id of the steam Game, here a list of installed games:"
    printsteamids
    echo "---"
    echo "Example: ./$0 NVMe 1962700"
    echo "Configures Subnautica 2 which is on NVMe"
}

printsteamids()
{
    # check if tools exist:
    if ! which awk > /dev/null 2>&1
    then
	echo "awk is not installed, STEAM ID Search does not work without it"
	return
    fi

    if ! which grep > /dev/null 2>&1
    then
	echo "grep is not installed, STEAM ID Search does not work without it"
	return
    fi

    if ! which tr > /dev/null 2>&1
    then
	echo "tr is not installed, STEAM ID Search does not work without it"
	return
    fi
    
    # What is happening here:
    # Search for "name" or "appid" in all appmanifest_* files
    # Throw away the first word of the search, that should always be "name" or "appid"
    # remove ALL newlines, so we have appid and name in one line
    # add a newline to the end of the line
    # remove all lines that contains Steam or Proton
    echo "\"STEAMID\" \"Gamename\""
    for i in "${HOME}"/.steam/root/steamapps/appmanifest_*
    do
	grep -e '"name"' -e '"appid"' $i \
	    | awk '{ $1=""; print $0 }' \
	    | tr -d '\n'
	echo ""
    done | grep -v -e Steam -e Proton
}

# check if both args are filed and print usage if not
if [[ -z "$1" ]] && [[ -z "$2" ]]
then
    usage
    exit 1
fi

# now we can do it
protoninstall "$1" "$2"

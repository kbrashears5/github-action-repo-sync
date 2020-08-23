#!/bin/bash

echo "Repository: $1"

# log inputs
echo "Inputs"
echo "---------------------------------------------"
REPO_TYPE="$INPUT_TYPE"
FILE_PATH="$INPUT_PATH"
GITHUB_TOKEN="$INPUT_TOKEN"
echo "Repo type    : $REPO_TYPE"
FILES=($RAW_FILES)
echo "Path         : $FILE_PATH"

# set temp path
TEMP_PATH="/ghars/"
cd /
mkdir "$TEMP_PATH"
cd "$TEMP_PATH"
echo "Temp Path       : $TEMP_PATH"
echo "---------------------------------------------"

echo " "

# initalize git
echo "Intiializing git"
git config --system core.longpaths true
git config --global core.longpaths true
git config --global user.email "action-bot@github.com" && git config --global user.name "Github Action"
echo "Git initialized"

echo " "

echo "###[group] $REPO_TYPE"

# clone the repo
REPO_URL="https://x-access-token:${GITHUB_TOKEN}@github.com/${repository}.git"
GIT_PATH="${TEMP_PATH}${repository}"
echo "Cloning [$REPO_URL] to [$GIT_PATH]"
git clone --quiet --no-hardlinks --no-tags --depth 1 $REPO_URL ${repository}

cd $GIT_PATH

# verify path exists
if [ ! test -f "$FILE_PATH" ]; then 
    echo "Path does not exist: [${FILE_PATH}]"
    return
fi

# default parameters
DESCRIPTION=""
WEBSITE=""
TOPICS=""

# determine repo type
if [ "$REPO_TYPE" == "npm" ]; then
    # install jq to parse json
    sudo apt-get update && sudo apt-get -y install jq
    #sudo chmod +x /usr/bin/jq # MAYBE need this

    # read in the description
    DESCRIPTION=`jq '.description' ${FILE_PATH}`
    WEBSITE=`jq '.homepage' ${FILE_PATH}`
    TOPICS=`jq '.keywords' ${FILE_PATH}`

elif [ "$REPO_TYPE" == "nuget" ]
    # TODO
    # read in file and store in variable
    # VALUE=`cat ${FILE_PATH}`
    # echo $VALUE
else
    echo "Unsupported repo type: [${REPO_TYPE}]"
fi
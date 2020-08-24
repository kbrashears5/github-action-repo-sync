#!/bin/bash

echo "Repository: [$GITHUB_REPOSITORY]"

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

# find username and repo name
REPO_INFO=($(echo $GITHUB_REPOSITORY | tr "/" "\n"))
USERNAME=${REPO_INFO[0]}
echo "Username: [$USERNAME]"
REPO_NAME=${REPO_INFO[1]}
echo "Repo name: [$REPO_NAME]"

# initalize git
echo "Intiializing git"
git config --system core.longpaths true
git config --global core.longpaths true
git config --global user.email "action-bot@github.com" && git config --global user.name "Github Action"
echo "Git initialized"

echo " "

# clone the repo
REPO_URL="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
GIT_PATH="${TEMP_PATH}${GITHUB_REPOSITORY}"
echo "Cloning [$REPO_URL] to [$GIT_PATH]"
git clone --quiet --no-hardlinks --no-tags --depth 1 $REPO_URL ${GITHUB_REPOSITORY}

cd $GIT_PATH

# verify path exists
echo "Checking that [${FILE_PATH}] exists"
if [ ! -f "$FILE_PATH" ]; then 
    echo "Path does not exist: [${FILE_PATH}]"
    return
fi

# default the parameters
DESCRIPTION=""
WEBSITE=""
TOPICS=""

echo "###[group] $REPO_TYPE"

# determine repo type
if [ "$REPO_TYPE" == "npm" ]; then
    echo "NPM"
    # read in the variables from package.json
    echo "Parsing ${FILE_PATH}"
    DESCRIPTION=`jq '.description' ${FILE_PATH}`
    WEBSITE=`jq '.homepage' ${FILE_PATH}`
    TOPICS=`jq '.keywords' ${FILE_PATH}`

elif [ "$REPO_TYPE" == "nuget" ]; then
    echo "NuGet"
    # TODO
    # read in file and store in variable
    # VALUE=`cat ${FILE_PATH}`
    # echo $VALUE
else
    echo "Unsupported repo type: [${REPO_TYPE}]"
fi

echo " "

# change nulls to empty strings
if [ "$DESCRIPTION" == null ]; then
    DESCRIPTION=""
fi
if [ "$WEBSITE" == null ]; then
    WEBSITE=""
fi
if [ "$TOPICS" == null ]; then
    TOPICS=""
fi

echo "Description: ${DESCRIPTION}"
echo "Website: ${WEBSITE}"
echo "Topics: ${TOPICS}"

echo " "

# update the repository with the values that were set
echo "Updating description and homepage for [${GITHUB_REPOSITORY}]"
BODY=`jq -n --arg description $DESCRIPTION --arg homepage $WEBSITE '{description:$description,homepage:$homepage}'`
curl \
    -X PATCH \
    -H "Accept: application/vnd.github.v3+json" \
    -u ${USERNAME}:${GITHUB_TOKEN} \
    -d $BODY \
    ${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}

echo "Updating topics for [${GITHUB_REPOSITORY}]"
curl \
    -X PUT \
    -H "Accept: application/vnd.github.mercy-preview+json" \
    -u ${USERNAME}:${GITHUB_TOKEN} \
    -d '{"names":["temp"]}' \
    ${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}/topics
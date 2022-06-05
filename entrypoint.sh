#! /bin/sh

# Set variables
IDENTITY_FILE=${IDENTITY_FILE:-""}
REPO_SYNC_DIR=${REPO_SYNC_DIR:-"/mnt$REPO_DIR"}


echo -e "\nWelcome to Memoir Manager v$VERSION ..."

# Optionnal: create alternative repo directory 
if [ ! -d "$REPO_DIR" ]; then mkdir -p "$REPO_DIR"; fi

# SSH

# start ssh agent
eval `ssh-agent -s` 1> /dev/null

# Set identity file if any
if [ -n "$IDENTITY_FILE" ]; then
    # try path provided by the user
    ssh-add "$IDENTITY_FILE" > /dev/null 2>&1 || \
    echo " failed to add identity."
else
    # default
    ssh-add > /dev/null 2>&1
fi


# Initialize repository
if [ -z "$(ls $REPO_DIR)" ]; then

    # clone repo if identity is valid
    ssh-add -l 1> /dev/null && git clone "$REPO" "$REPO_DIR"
fi


#  Case: User provided a mount point for sync. 
if [ -d "$REPO_SYNC_DIR" ]; then
    
    if [ "pull" == "$REPO_SYNC_MODE" ]; then
        # Sync from repo to mount point
        mgr-watch "$REPO_DIR" "$REPO_SYNC_DIR"

    elif [ "push" == "$REPO_SYNC_MODE" ]; then
        # Sync from mount point to repo
        mgr-watch "$REPO_SYNC_DIR" "$REPO_DIR"
    fi
fi

# execute command
exec "$@"

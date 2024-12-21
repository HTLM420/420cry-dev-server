#!/bin/sh
set -e

if [ "$USER_NAME" = "root" ]; then
    echo "No need to setup a user and group because Docker images are build with a root user"

    # Setup symlink for root's home so the Dockerfiles can just write to /home/$USER_NAME
    ln -s /root /home/root

    exit 0
fi

if id "$USER_ID" >/dev/null 2>&1; then
    echo "User with '$USER_ID' already exists. Did you build this Docker image using a system user? Please retry with your own user."
    exit 2
fi

GROUP_NAME=$USER_NAME

# Create group with with the same name as the user. The -f ensures the command also exits successfully when the group already existed.
echo "Creating group '$GROUP_NAME' with ID '$GROUP_ID'"
ADD_GROUP_RESULT=0
addgroup --force-badname --gid "$GROUP_ID" "$GROUP_NAME" || ADD_GROUP_RESULT=$?

# Rename group if it already existed (exit code is 1).
# This has no special usage but is more convenient for the end-user of this Docker image.
if [ $ADD_GROUP_RESULT -eq 1 ]; then
    OLD_GROUP_NAME=$(getent group "$GROUP_ID" | cut -d: -f1)

    echo "Renaming group '$OLD_GROUP_NAME' to '$GROUP_NAME'"
    groupmod --new-name "$GROUP_NAME" "$OLD_GROUP_NAME"
fi

# Create user
echo "Creating user '$USER_NAME' with ID '$USER_ID'"
adduser --force-badname  --disabled-password --gecos '' --uid "$USER_ID" --gid "$GROUP_ID" "$USER_NAME"

# Add user to sudoers group and file so it can run commands with root privileges
usermod -a -G sudo "$USER_NAME"
echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers

# workaround for large USER_IDs (https://github.com/moby/moby/issues/5419#issuecomment-872773893)
rm /var/log/lastlog /var/log/faillog
touch /var/log/lastlog 
touch /var/log/faillog

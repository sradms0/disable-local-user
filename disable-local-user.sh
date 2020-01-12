#!/bin/bash

# This script disables or deletes a user from a GNU/Linux system, with optional archival.

# Display the usage and exit.
usage() {
    echo "Usage: ${0} [-dra] USER [USERNAME]" >&2
    echo 'Disable a local GNU/Linux account.'
    echo '  -d  Deletes accounts'
    echo '  -r  Removes the home directory associated with the accounts)'
    echo '  -a  Creates an archive of the home directory associated with the accounts(s).'
   exit 1 
}

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
    echo 'Please run with sudo or as root.'
    exit 1
fi

# Parse the options.
while getopts dra OPTION
do
    case ${OPTION} in
        d)
            DELETE='true'
            ;;
        r)
            REMOVE_HOME='true'
            ;;
        a)
            ARCHIVE='true'
            ;;
        ?)
            usage
            ;;
    esac
done

# Remove the options while leaving the remaining arguments.
shift $(( $OPTIND - 1 ))

# If the user doesn't supply at least one argument, give them help.
if [[ "${#}" -eq 0 ]]
then 
    usage
fi

# Loop through all the usernames supplied as arguments.

    # Make sure the UID of the account is at least 1000.

    # Create an archive if requested to do so.

    # Make sure the ARCHIVE_DIR directory exists.

    # Archive the user's home directory and move it into the ARCHIVE_DIR

    # Delete the user.

    # Check to see if the userdel command succeeded.

    # Don't tell the user that an account was deleted when it hasn't been.

    # Check to see if the chage command succeeded.

    # Don't tell the user that an account was disabled when it hasn't been.


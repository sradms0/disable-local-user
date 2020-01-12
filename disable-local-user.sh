#!/bin/bash

# This script disables or deletes a user from a GNU/Linux system, with optional archival.

readonly ARCHIVE_DIR='/archive'

# Display the usage and exit.
usage() {
    echo "Usage: ${0} [-dra] USER [USERNAME]" >&2
    echo 'Disable a local GNU/Linux account.'
    echo '  -d  Deletes accounts'
    echo '  -r  Removes the home directory associated with the accounts)'
    echo '  -a  Creates an archive of the home directory associated with the accounts(s).'
   exit 1 
}

# Make sure the user exists and UID of the account is at least 1000.
assert_user() {
    local _UID=$(id -u "${USERNAME}" 2> /dev/null)
    if [ -z "${_UID}" ]
    then
        echo "${USERNAME} does not exist." >&2
        exit 1
    elif [[ "${_UID}" -lt 1000 ]]
    then
        echo "UID (${_UID}) for user ${USERNAME} is less than 1000" >&2
        exit 1
    fi
}

# Disable user
disable() {
   chage -E 0 "${USERNAME}" 2> /dev/null
   if [[ "${?}" -ne 0 ]]
   then
       echo "Unable to disable ${USERNAME}"
       exit 1
   fi
} 

# Delete user
delete() {
    userdel "${USERNAME}" 2> /dev/null
    if [[ "${?}" -ne 0 ]]
    then
        echo "Unable to delete ${USERNAME}" >&2
        exit 1
    fi
}

# Remove user
remove() {
    rm -rf "/home/${USERNAME}"
}

# Create the archive directory if it doesn't exist.
assert_archive_dir() {
    if [ ! -d "${ARCHIVE_DIR}" ]
    then
        mkdir "${ARCHIVE_DIR}"
    fi
}

# Archive user directory.
archive() {
    tar -cvzf "${ARCHIVE_DIR}/${USERNAME}".tar.gz -C "/home" "${USERNAME}"
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
            REMOVE='true'
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
while [[ "${#}" -gt 0 ]]  
do
    readonly USERNAME="${1}"
    assert_user

    if [[ "${ARCHIVE}" = 'true' ]]
    then
        echo "-archiving ${USERNAME}-"
        assert_archive_dir
        archive
    fi

    if [[ "${DELETE}" = 'true' ]]
    then 
        echo "-deleting ${USERNAME}-"
        delete
    else
        echo "-disabling ${USERNAME}-"
        disable
    fi

    if [[ "${REMOVE}" = 'true' ]]
    then
        echo "-removing ${USERNAME}-"
        remove
    fi

    shift
done

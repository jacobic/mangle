#! /bin/sh
# � M E C Swanson 2008
#
#script called by wrapper script setup_mangle_environment to set
#mangle environment variables
#
#USAGE: type 'source setup_mangle_environment' in the base mangle directory
#If environment is setup correctly, typing
#'echo $MANGLEBINDIR; echo $MANGLESCRIPTSDIR; echo $MANGLEDATADIR'
#should print out the names of the appropriate directories.
#
#If the above command doesn't work, try 'source setup_mangle_environment $PWD/' 
#
#
#You can also use 'source <MANGLEDIR>setup_mangle_environment.sh <MANGLEDIR>'
#where <MANGLEDIR> is the path to the base mangle directory, e.g., /home/username/mangle2.0/
#
#To automatically set up the mangle environment variables when you start your shell, 
#add the following line to your .bashrc (or .tcshrc, or .cshrc, or .login, or .profile) 
#(replace <MANGLEDIR> with the path to your mangle installation):
#
#source <MANGLEDIR>setup_mangle_environment <MANGLEDIR>

#If no command line argument is given, assume we're running in the mangle directory 

if [ "$1" = "" ]; then
    MANGLEDIR=$PWD/
#otherwise use the path in the first command-line argument as $MANGLEDIR
else
    MANGLEDIR=$1
fi

MANGLEBINDIR="${MANGLEDIR}bin"
MANGLESCRIPTSDIR="${MANGLEDIR}scripts"
MANGLEDATADIR="${MANGLEDIR}masks"

#check to make sure directories exist
if [ ! -d $MANGLEBINDIR ]; then
    echo >&2 "ERROR: The directory $MANGLEBINDIR does not exist"
fi
if [ ! -d $MANGLESCRIPTSDIR ]; then
    echo >&2 "ERROR: The directory $MANGLESCRIPTSDIR does not exist"
fi
if [ ! -d $MANGLEDATADIR ]; then
    echo >&2 "ERROR: The directory $MANGLEDATADIR does not exist"
fi
if [ ! -d $MANGLEBINDIR ] || [ ! -d $MANGLESCRIPTSDIR ] || [ ! -d $MANGLEDATADIR ]; then
    echo >&2 ""
    echo >&2 "USAGE: type 'source setup_mangle_environment.sh' in mangle 'scripts' directory."
    echo >&2 "Or use 'source <MANGLEDIR>scripts/setup_mangle_environment.sh <MANGLEDIR>'"
    echo >&2 "where <MANGLEDIR> is the path to the base mangle directory," 
    echo >&2 "e.g., /home/username/mangle2.0/"
    exit 1
fi
 
#export environment variables and put bin and scripts directories in the path
if export MANGLEBINDIR=$MANGLEBINDIR >& /dev/null ; then
    cat <<EOF > setup_script
export MANGLEBINDIR=$MANGLEBINDIR
export MANGLESCRIPTSDIR=$MANGLESCRIPTSDIR
export MANGLEDATADIR=$MANGLEDATADIR
export PATH=$PATH:$MANGLEBINDIR:$MANGLESCRIPTSDIR
EOF
elif setenv MANGLEBINDIR $MANGLEBINDIR >& /dev/null ; then
    cat <<EOF > setup_script
setenv MANGLEBINDIR $MANGLEBINDIR
setenv MANGLESCRIPTSDIR $MANGLESCRIPTSDIR
setenv MANGLEDATADIR $MANGLEDATADIR    
setenv PATH $PATH:$MANGLEBINDIR:$MANGLESCRIPTSDIR
EOF
else       
    echo >&2 "ERROR: did not detect either export or setenv in your shell." 
    echo >&2 "make_setup_script.sh cannot set the mangle environment variables."
    exit 1
fi



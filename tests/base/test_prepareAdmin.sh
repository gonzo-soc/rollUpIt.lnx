#! /bin/bash

set -o errexit
set -o xtrace
set -o nounset

ROOT_DIR_ROLL_UP_IT="/usr/local/src/post-scripts/rollUpIt.lnx"
# ROOT_DIR_ROLL_UP_IT="/usr/local/src/rollUpIt.lnx"

source "$ROOT_DIR_ROLL_UP_IT/libs/addColors.sh"
source "$ROOT_DIR_ROLL_UP_IT/libs/addRegExps.sh"
source "$ROOT_DIR_ROLL_UP_IT/libs/addTty.sh"
source "$ROOT_DIR_ROLL_UP_IT/libs/install/install.sh"
source "$ROOT_DIR_ROLL_UP_IT/libs/commons.sh"
source "$ROOT_DIR_ROLL_UP_IT/libs/logging/logging.sh"
source "$ROOT_DIR_ROLL_UP_IT/libs/sm.sh"

if [ $(isDebian_SM_RUI) = "true" ]; then
  source "$ROOT_DIR_ROLL_UP_IT/libs/lnx_debian09/commons.sh"
  source "$ROOT_DIR_ROLL_UP_IT/libs/lnx_debian09/sm.sh"
elif [ $(isCentOS_SM_RUI) = "true" ]; then
  source "$ROOT_DIR_ROLL_UP_IT/libs/lnx_centos07/install/install.sh"
  source "$ROOT_DIR_ROLL_UP_IT/libs/lnx_centos07/commons.sh"
  source "$ROOT_DIR_ROLL_UP_IT/libs/lnx_centos07/sm.sh"
else
  onFailed_SM_RUI "Error: can't determine the OS type"
  exit 1
fi
#:
#: Suppress progress bar
#: It is used in case of the PXE installation
#:
SUPPRESS_PB_COMMON_RUI="FALSE"

#:
#: PXE is not able to operate the systemd during installation
#:
PXE_INSTALLATION_SM_RUI="FALSE"

trap "onInterruption_COMMON_RUI $? $LINENO $BASH_COMMAND" ERR EXIT SIGHUP SIGINT SIGTERM SIGQUIT RETURN

main() {
  local -r debug_prefix="debug: [$0] [ $FUNCNAME[0] ] : "
  printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"

  local -r exec_user="$(whoami)"
  local -r sudo_user="${SUDO_USER:-}"
  local -r user="${1:-$(whoami)}"
  local pwd=""
  local prompt=""

  # password quality we can define in /etc/security/pwquality.conf
  printf "\nEnter password for the user [$user]\n"

  # from @https://stackoverflow.com/questions/1923435/how-do-i-echo-stars-when-reading-password-with-read
  unset pwd
  while IFS= read -p "$prompt" -r -s -n 1 char; do
    if [[ $char == $'\0' ]]; then
      break
    fi
    prompt='*'
    pwd+="$char"
  done

  if [ -z "$pwd" ]; then
    onErrors_SM_RUI "$debug_prefix ${RED_ROLLUP_IT} Empty password  ${END_ROLLUP_IT}"
    exit 1
  fi
  prepareUser_SM_RUI "$user" "$pwd"

  printf "$debug_prefix ${GRN_ROLLUP_IT} ENTER the function ${END_ROLLUP_IT} \n"
}

if [ ! -e "${ROOT_DIR_ROLL_UP_IT}/log" ]; then
  mkdir "${ROOT_DIR_ROLL_UP_IT}/log"
fi

LOG_FP=$(getShLogName_COMMON_RUI $0)
if [ ! -e "/var/log/post-scripts" ]; then
  mkdir "/var/log/post-scripts"
fi

main $@ 2>&1 | tee "/var/log/post-scripts/${LOG_FP}"
exit 0

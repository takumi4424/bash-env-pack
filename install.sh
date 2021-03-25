#!/bin/bash
set -eu

# check requirements
if ! command -v git curl > /dev/null 2>&1; then
  echo "error: 'git' and 'curl' command required."
  exit 1
fi

repo_name="bash-env-pack"

here="$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)"
if ! git -C ${here} rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  # probably installing using curl
  if [[ -d ${HOME}/.${repo_name} ]]; then
    echo "error: '${HOME}/.${repo_name}' already exists. Try to run 'install.sh' script in the directory."
    exit 1
  fi
  git clone https://github.com/takumi4424/${repo_name}.git ${HOME}/.${repo_name}
  here=${HOME}/.${repo_name}
  echo "Repository ${repo_name} cloned as ${here}."
fi

# create links
if [[ -f ${HOME}/.vimrc ]]; then
  echo "warning: '${HOME}/.vimrc' already exists. (The symbolic link to '${here}/vimrc' was not created.)"
else
  ln -s ${here}/vimrc ${HOME}/.vimrc
  echo "Symbolic link created: ${HOME}/.vimrc -> ${here}/vimrc"
fi
if [[ -f ${HOME}/.inputrc ]]; then
  echo "warning: '${HOME}/.inputrc' already exists. (The symbolic link to '${here}/inputrc' was not created.)"
else
  ln -s ${here}/inputrc ${HOME}/.inputrc
  echo "Symbolic link created: ${HOME}/.inputrc -> ${here}/inputrc"
fi

# install vim plugin manager
dein_path=${HOME}/.vim/bundles/dein.vim
if [[ ! -d ${dein_path} ]]; then
  echo "Installing vim plugin manager..."
  mkdir -p $(dirname ${dein_path})
  git \
    -C $(dirname ${dein_path}) \
    -c advice.detachedHead=false \
    clone \
      -q \
      --depth 1 \
      -b 1.0 \
      https://github.com/Shougo/dein.vim;
  echo "Installed."
fi

source_text="if [[ -f ${here}/bashrc ]]; then source ${here}/bashrc; fi"
if ! cat ${HOME}/.bashrc | grep -F "${source_text}" > /dev/null 2>&1; then
  echo "" >> ${HOME}/.bashrc
  echo "${source_text}" >> ${HOME}/.bashrc
  echo "" >> ${HOME}/.bashrc
fi

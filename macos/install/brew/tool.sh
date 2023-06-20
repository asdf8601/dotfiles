#!/usr/bin/env bash

case "$1" in
  install)
    echo "Installing packages"
    brew install $(cat packages.txt)
    ;;
  backup)
    echo "Backing up packages"
    brew list > packages.txt
    ;;
  restore)
    echo "Restoring packages"
    brew install $(cat packages.txt)
    ;;
  *)
    echo "Usage: $0 {install|backup|restore}"
    exit 1
esac

#! /bin/bash

main() {
  PACKAGE_MANAGER=$1

  PACKAGE_MANAGER_LIST=("apt-get" "S" "dnf" "apt" "nala")
  
  for i in "${PACKAGE_MANAGER_LIST[@]}"; do
  
    if [ "$i" == "$PACKAGE_MANAGER" ]; then
      echo "sudo $i install test"
    fi

  done

}

main "$@"

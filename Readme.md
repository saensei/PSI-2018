Project Requirements 
HA WEB Application :

1.Vagrant/terraform/docker/etc (with virtualbox/kvm/cloud) setup of 1-5 vms witch will cover:

    3 DB nodes (clutered mysql - MariaDB with storage)
    3 Gluster nodes for persistent shared storage backend for web nodes.
    2 WEB NODES (apache/nginx/other) with CMS on it (drupal/wordpress/etc)
    ALL Services that are using HA solutions (db and Web servers) should be covered by Loadballancer with VIP-Virtual IP

AS A FINAL PRODUCT OF YOUR WORK I'M EXPECTING WORKING SOULTION WITH ONE "VAGRANT UP/TERRRAFORM APPLY/EQUIVALENT"

WORK should be commited as a pull request to git repository https://github.com/kornatka/PSI-2018

HELP HERE:

Virtualization:

    https://www.docker.com/
    https://docs.docker.com/compose/
    https://www.virtualbox.org/
    https://www.linux-kvm.org/
    https://xenserver.org/

Automation:

    https://www.vagrantup.com/
    https://www.terraform.io/
    https://www.gnu.org/software/bash/manual/bashref.html

DB:

    https://mariadb.com/kb/en/library/what-is-mariadb-galera-cluster/

APP:

    https://www.drupal.org/
    https://wordpress.org/

GIT:

    https://git-scm.com/

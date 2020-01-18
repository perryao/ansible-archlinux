# Ansible Galaxy Requirements
    $ ansible-galaxy install -r requirements.yml

# Usage

    $ sudo ansible-playbook -i localhost playbook.yml
# Ranking Mirrors

    $ curl -s "https://www.archlinux.org/mirrorlist/?country=FR&country=GB&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -

# Backups
Duplicity is used for backups. To run an adhoc backup,

    $ AWS_PROFILE= AWS_BUCKET_NAME= ./roles/base/files/backup.sh

# TODO

- [ ] install goimports

#!/bin/env bash
set -e


ansible-playbook -i ./$1  ../ansible/playgitlabserver.yml
ansible-playbook -i ./$1  ../ansible/playdb.yml
ansible-playbook -i ./$1  ../ansible/playwordpress.yml
ansible-playbook -i ./$1  ../ansible/playproxy.yml
ansible-playbook -i ./$1  ../ansible/playmonitoring.yml
ansible-playbook -i ./$1  ../ansible/playgrunner.yml
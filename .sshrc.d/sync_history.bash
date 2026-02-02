#! /bin/bash

export PROMPT_COMMAND='history -a'
tail -n 1 -f ~/.bash_history | perl -pe 's/#(\d+)\n/: $1:0;/mg;$| = 1;' | netcat 127.0.0.1 9999 &>>~/.bash_history &

# sshrc -R 127.0.0.1:9999:127.0.0.1:9999 root@localhost -p 2222
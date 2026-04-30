#!/bin/bash
git config --global alias.ilog "!f() { git log --pretty=format:'%C(yellow bold)%s%Creset %C(dim white)|%Creset %C(blue bold)%an%Creset %C(red bold)%ad%Creset' --date=format:'%Y-%m-%d %H:%M' \$@; }; f"

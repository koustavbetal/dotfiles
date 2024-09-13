# neofetch ================================================|
alias sys='neofetch'

# cpufetch ================================================|
alias cpu='cpufetch'

#tldr
# gdu --> storage analyser
# cmetrix
# btop
# ffmpeg
# speedread
# tmux

# ascii-image-generator ===================================|
alias ascii='ascii-image-converter -C'

# bat ======================================================|
alias bat='batcat'

# eza ======================================================|
alias  ls='eza --color=always --icons=always  --long --git --no-time --no-user --no-permissions'


###CUSTOM ALIASES ###
#===================#

#<<<< apt fx >>>>#
alias refresh='clear && source ~/.bashrc'
alias boost='sudo nvidia-smi -pm 1'
alias edit='sudo nano ~/.bashrc'
alias file='nautilus .'
alias jetpy='pycharm-community'

alias src='source install/setup.bash'
alias srcl='source install/local_setup.bash'
alias cb='colcon build'
alias cbs='colcon build --symlink-install'
alias rosnl='ros2 node list'
alias rostl='ros2 topic list'
alias rqtg='rqt_graph'

#<<<< System Upgrade >>>>#
alias sysupd='sudo apt update'
alias sysupg='sudo apt upgrade'
alias sysup='sudo apt update && sudo apt upgrade'

#<<<< apt install >>>>#
alias sysinst='sudo apt install'
alias sysrm='sudo apt remove'

#<<<< snap remove >>>>#
alias snapinst='sudo snap install'
alias snaprm='sudo snap remove'

#<<<< mkdir buff >>>>#
alias mkdir='mkdir -pv'

#<<<< Navigate directory ++ >>>>#
alias ..='cd ..'
alias ...='cd ../..'

#<<<< ROS2 >>>>#
alias rosdepinst='echo "!!!!!! Use this cmd, ONLY when you are in the <_WS> folder !!!!!" && rosdep install -i --from-path src --rosdistro humble -y'
alias rosdepinit='sudo rosdep init && rosdep update'


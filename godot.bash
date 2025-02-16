#basic bash script to run the godot project

tmux rename-window 'nvim'
tmux new-window -n "git"
tmux new-window -n "godot": '/home/jonah/Godot/Godot_v4.3-stable_linux.x86_64 -e' 
nvim

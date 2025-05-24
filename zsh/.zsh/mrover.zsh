# mrover configurations

if command -v rosdep &> /dev/null; then
	alias mrover="mamba deactivate && cd ~/dev/rover/src/mrover && source ~/dev/rover/src/mrover/venv/bin/activate" # && ~/dev/rover/install/setup.zsh"

	ROS2_WS_PATH="~/dev/rover"
	source /opt/ros/humble/setup.zsh
	CATKIN_SETUP_PATH="${ROS2_WS_PATH}/install/setup.zsh"
	if [ -f ${CATKIN_SETUP_PATH} ]; then
		source ${CATKIN_SETUP_PATH}
	fi

	# bun completions
	# [ -s "/home/mrover/.bun/_bun" ] && source "/home/mrover/.bun/_bun"

	# bun
	export BUN_INSTALL="$HOME/.bun"
	export PATH="$BUN_INSTALL/bin:$PATH"

	# ros2 completions
	eval "$(register-python-argcomplete3 ros2)"
	eval "$(register-python-argcomplete3 colcon)"
fi

# cmake config fixes
export CMAKE_IGNORE_PREFIX_PATH="$HOME/miniforge3"
export TBB_DIR="/usr/lib/x86_64-linux-gnu/cmake/TBB"

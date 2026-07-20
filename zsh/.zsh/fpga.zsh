# FPGA settings and dev tools

# VERSION="20.1"
VERSION="25.1std"

# quartus
export PATH="$PATH:$HOME/quartus/$VERSION/quartus/bin"

# questa/modelsim
# export PATH="$PATH:$HOME/fpga/quartus/24.1std/questa_fse/bin"
# export PATH="$PATH:$HOME/fpga/altera/24.1std/questa_fse/bin"
export PATH="$PATH:$HOME/quartus/$VERSION/modelsim_ase/bin"

export QSYS_ROOTDIR="/home/edurso/quartus/$VERSION/quartus/sopc_builder/bin"
# export SALT_LICENSE_FILE=/home/edurso/fpga/license/LR-233714_License.dat:$SALT_LICENSE_FILE
# export SALT_LICENSE_FILE="/home/edurso/fpga/license/LR-233714_License.dat"
# echo "configured altera fpga license"

# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
alias ls="ls --color"
alias dir="dir --color"

alias launch="cs; sbatch bin/launch-code-server.sbatch; cd -"
alias show="cat /ibex/scratch/jangira/code-server/bin/launch-code-server.err;"
alias wd="cd /ibex/scratch/jangira/"
alias cs="cd /ibex/scratch/jangira/code-server"
alias la="ls -a"
alias sq="squeue -u jangira"
alias sqq="squeue -u jangira --start"
alias qs="qstat -u jangira"

jobDetails(){
  sacct --format=User,Account,State,JobID,JobName,AllocCPUS,AllocNodes,NodeList,CPUTime,ReqMem,MaxRSS,MaxVMSize,Elapsed,AllocTRES -j $1
  echo -e "\nGo to WorkDir:\n"
  echo -e "cd $(scontrol show job $1 | grep "WorkDir" | cut -d"=" -f2) \n"
}


# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# To change path shown on bash
PS1=':$(echo $PWD | rev | cut -d '/' -f 1 | rev)-> '

# User specific aliases and functions
export PATH="/ibex/scratch/jangira/qe/npr/ZScripts/tools:$PATH"
export PATH="/ibex/scratch/jangira/root/tools:$PATH"
export PATH="/home/jangira/.local/bin:$PATH"
export PATH=/home/jangira/application/vaspkit/1.4.0/vaspkit.1.4.0/bin:${PATH}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jangira/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jangira/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jangira/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jangira/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


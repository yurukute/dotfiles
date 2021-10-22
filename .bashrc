#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

eval "`dircolors ~/.dircolors`"
alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# build and run code
build () {
    case $1 in
		*.cpp)
			output=${1%".cpp"}
        	g++ $1 -o $output && ./$output
			echo
			rm $output;;
    	*.c)
			output=${1%".c"}
			gcc $1 -o $output && ./$output
			echo
			rm $output;;
    	*.py)
			python -u ./$1;;
    	*.java)
			classpath="../"
			if [ $# -eq 2 ]; then
				classpath=$2
			fi
			javac $1 -cp $classpath -d $classpath && java -cp $classpath $1
			rm -f "${1%.*}.class"
			echo;;
    esac
}

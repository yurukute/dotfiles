#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

build () {
    case $1 in
		*.cpp)  output=$1
        		output=${output%".cpp"}
        		g++ $1 -o $output && ./$output && echo
        ;;
    	*.c)    output=$1
        		output=${output%".c"}
            	gcc $1 -o $output && ./$output && echo
        ;;
    	*.py)   python -u ./$1
        ;;
    	*.java) output=$1
				output=${output%".java"}
				javac $1 && java $output && echo
	;;
    esac
}

clear

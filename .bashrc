#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# build and run code
build () {
    case $1 in
	*.cpp)  output=$1
        	output=${output%".cpp"}
        	g++ $1 -o $output && ./$output && rm ./$output && echo
		;;
    	*.c)    output=$1
        	output=${output%".c"}
            	gcc $1 -o $output && ./$output && rm ./$output && echo
		;;
    	*.py)   python -u ./$1
		;;
    	*.java) output=$1	      
		javac $1 && java $1 && echo 
		;;
    esac
}

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors ~/.dircolors`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

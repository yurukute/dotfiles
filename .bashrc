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
			output=${$1%".cpp"}
        	g++ $1 -o $output
			./$output
			echo
			rm $output;;
    	*.c)
			output=${$1%".c"}
			gcc $1 -o $output
			./$output
			echo
			rm $output;;
    	*.py)
			python -u ./$1;;
    	*.java)
			if [ $# -eq 2 ]; then
				javac -d $2 $1
				java -cp $2 $1
			else
				javac $1 && java $1
				output=${$1%".cpp"}
				rm $output
			fi						
			echo;;
    esac
}

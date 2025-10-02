#!/bin/zsh

dirs_file="$HOME/.dirs_stack"


main() {
	
	[[ $1 = 'a' ]] && insert_path $2 && return 0
	[[ $1 = 'r' ]] && delete_path    && return 0
	[[ $1 = 'o' ]] && show_options   && return 0


	read_sources

	[[ $1 == <-> ]] && go "$1" && return 0

	menu
	read_choice "go to: "

	[[ -z $choice ]] && return 0      # if empty, leave
	go "$choice" && return 0

}


insert_path() {
	the_file=$dirs_file

	[[ -n $1 ]] && new_path="$1" || read new_path

	new_path="${new_path/#$HOME/~}"       # tilde contraction 
	touch "$the_file"                     # ensure file exists

	if grep -Fxq -- "$new_path" "$the_file"; then
		write "\nPath $new_path alread exists.\n"
	else 
		echo "$new_path" >> "$the_file"
	fi
}


delete_path() {
	the_file=$dirs_file
	read_file

	write "Select the path to remove"
	menu
	read_choice "Index: "

	if [[ $choice == <1-> && $choice -le $#paths_f ]]; then
		to_remove="$paths_f[$choice]"

		remaining_lines=$(grep -Fvx -- "$to_remove" "$the_file")
		echo "$remaining_lines" >| "$the_file"
	fi
}


read_file() {
	if ! [[ -r $dirs_file ]]; then
		write "\nFile %s is missing :(\n" "$dirs_file"
		return 1
	fi

	paths_f=()

	while IFS= read -r line; do
		paths_f+=("$line")
	done < $dirs_file
}



read_dirs() {
	paths_d=("${(f)$(dirs -p | cut -f2)}")


	paths_d=(${paths_d[@]:1})            # remove current dir (the first one)
	paths_d=(${paths_d:#\~})             # remove the HOME

	# paths_d=("${paths_d[@]}")          # Original order
	paths_d=("${(O@a)paths_d[@]}")       # Reverse order
}


read_sources() {
	read_file
	read_dirs

	opts=("${paths_f[@]}" "${paths_d[@]}")
	len=$#opts
}






write() {
	[[ $# -eq 0 ]] && print >&2 && return  

	local fmt="$1"            # first parameter is the format string
    shift || true             # "consume" $1, now $1 is the next argument
    printf "$fmt" "$@" >&2    # send to stderr
}


menu() {
	bold_red='\033[1;31m%s\033[0m %s\n'
	bold_blue='\033[1;34m%s\033[0m %s\n'

	write
	for i in {1..$#paths_f}; do
		write $bold_red "$i" "${paths_f[i]}"
	done

	(( ${#paths_d} )) && write

		typeset -i base=$#paths_f
		for (( j=1; j<=${#paths_d}; j++ )); do
			idx=$(( base + j ))
			write "$bold_blue" "$idx" "${paths_d[j]}"
		done
}

show_options() {
	read_sources
	menu
	write
}

read_choice() {
	write
	read "?$1" choice
}

go() {
	if [[ $1 -ge 0 && $1 -le $len ]]; then
		target="${opts[$1]}"
		target="${target/#\~/$HOME}"      # expand ~ 
		# cd -- "${target}"
		echo $target
		return 0
	else
		write "Invalid index: $1"
	fi
}


# === Main ===

main "$@"

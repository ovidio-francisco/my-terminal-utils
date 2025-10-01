#!/bin/zsh

dirs_file="$HOME/.dirs_stack"

main() {
	
	[[ $1 = 'a' ]] && insert_path $2 && return 0
	[[ $1 = 'r' ]] && delete_path    && return 0


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
		printf "\nPath $new_path alread exists.\n"
	else 
		echo "$new_path" >> "$the_file"
	fi
}


delete_path() {
	the_file=$dirs_file
	read_file

	echo "Select the path to remove"
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
		printf "\nFile %s is missing :(\n" "$dirs_file"
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


menu() {
	bold_red='\033[1;31m%s\033[0m %s\n'
	bold_blue='\033[1;34m%s\033[0m %s\n'

	echo
	for i in {1..$#paths_f}; do
		printf $bold_red "$i" "${paths_f[i]}"
	done

	(( ${#paths_d} )) && print

		typeset -i base=$#paths_f
		for (( j=1; j<=${#paths_d}; j++ )); do
			idx=$(( base + j ))
			printf "$bold_blue" "$idx" "${paths_d[j]}"
		done
}

read_choice() {
	echo
	read "?$1" choice
}

go() {
	if [[ $1 -ge 0 && $1 -le $len ]]; then
		target="${opts[$1]}"
		target="${target/#\~/$HOME}"      # expand ~ 
		# echo $target
		cd -- "${target}"
		return 0
	else
		echo "Invalid index: $1"
	fi
}


unset_variables() {
	unset dirs_file
	unset new_path
	unset to_remove
	unset remaining_lines
	unset paths_f
	unset paths_d
	unset opts
	unset len
	unset bold_red
	unset bold_blue
	unset target
}

unset_functions() {
	unset -f main
	unset -f insert_path
	unset -f delete_path
	unset -f read_file
	unset -f read_dirs
	unset -f read_sources
	unset -f menu
	unset -f read_choice
	unset -f go
	unset -f unset_variables
	unset -f unset_functions
}


# === Main ===

main "$@"

unset_variables
unset_functions





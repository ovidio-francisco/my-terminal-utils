#!/bin/zsh


main() {
	read_sources

	[[ -n $1 ]] && go "$1" && return 0

	menu
	read_choice

	[[ -z $choice ]] && return 0      # if empty, leave
	go "$choice" && return 0

}



read_sources() {
	dirs_file="$HOME/.dirs_stack"

	if ! [[ -r $dirs_file ]]; then
		printf "\nFile %s is missing :(\n" "$dirs_file"
		return 1
	fi

	paths_f=()

	while IFS= read -r line; do
		paths_f+=("$line")
	done < $dirs_file


	paths_d=("${(f)$(dirs -p | cut -f2)}")


	paths_d=(${paths_d[@]:1})            # remove current dir (the first one)
	paths_d=(${paths_d:#\~})             # remove the HOME

	# paths_d=("${paths_d[@]}")          # Original order
	paths_d=("${(O@a)paths_d[@]}")       # Reverse order

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
	read "?go to: " choice
}

go() {
	if [[ $1 == <-> && $1 -ge 0 && $1 -le $len ]]; then
		target="${opts[$1]}"
		target="${target/#\~/$HOME}"      # expand ~ 
		# echo $target
		cd -- "${target}"
		return 0
	else
		echo "Invalid index: $1"
	fi
}



main "$@"


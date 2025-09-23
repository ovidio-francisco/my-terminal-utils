#!/bin/zsh

dirs_file="$HOME/.dirs_stack"

if ! [[ -r $dirs_file ]]; then
	printf "\nFile %s is missing :(\n" "$dirs_file"
	return 1
fi


setopt pushd_silent   # suppress the numbering
typeset -U arr        # prevents duplicates in arr

arr=("${(f)$(dirs -p | cut -f2)}")


# remove current dir (the first one)
arr=(${arr[@]:1})


# remove the HOME
arr=(${arr:#\~})


while IFS= read -r line; do
	arr+=("$line")
done < $dirs_file


# MENU

bold='\033[1m %s\033[0m → %s\n'
bold_red='\033[1;31m %s\033[0m → %s\n'

printf '\n'$bold_red 'q' 'nowhere'

echo
for i in {1..$#arr}; do
  idx=$((i-1))
  printf $bold_red "$idx" "${arr[i]}"
done



echo
read "?go to: " g

if [[ $g == 'q' ]]; then
	printf "\nBye :)\n"
	return 0
fi

if ! [[ $g == <-> ]]; then
  print -r -- "Invalid choice: $g (not a number)"
  return 1
fi


g=$((g+1))       # zsh arrays are 1 indexed

choice="${arr[g]}"
target="${choice/#\~/$HOME}"     # expand ~ 


# check it's a directory, then cd
if [[ -d $target ]]; then
  cd -- "$target"
else
  print -r -- "Path not found: $choice"
  return 1
fi



#!/bin/zsh

dirs_file="$HOME/.dirs_stack"

if ! [[ -r $dirs_file ]]; then
	printf "\nFile %s is missing :(\n" "$dirs_file"
	return 1
fi


setopt pushd_silent   # suppress the numbering
typeset -U paths_f       # prevents duplicates in paths_f


paths_f=()

while IFS= read -r line; do
	paths_f+=("$line")
done < $dirs_file


paths_d=("${(f)$(dirs -p | cut -f2)}")


paths_d=(${paths_d[@]:1})            # remove current dir (the first one)
paths_d=(${paths_d:#\~})             # remove the HOME

# paths_d=( "${paths_d[@]}" )        # Original order
paths_d=( "${(O@a)paths_d[@]}" )     # Reverse order


# MENU
bold_red='\033[1;31m%s\033[0m %s\n'
bold_blue='\033[1;34m%s\033[0m %s\n'


echo
for i in {1..$#paths_f}; do
  idx=$((i-1))
  printf $bold_red "$idx" "${paths_f[i]}"
done

echo
for j in {1..$#paths_d}; do
  idx=$((j-1+i))
  printf $bold_blue "$idx" "${paths_d[j]}"
done


opts=( "${paths_f[@]}" "${paths_d[@]}" )


echo
read "?go to: " g

if ! [[ $g == <-> ]]; then
  printf "\nBye :)\n"
  return 0
fi


g=$((g+1))       # zsh arrays are 1 indexed

choice="${opts[g]}"
target="${choice/#\~/$HOME}"     # expand ~ 


# check it's a directory, then cd
if [[ -d $target ]]; then
  cd -- "$target"
else
  print -r -- "Path not found: $choice"
  return 1
fi



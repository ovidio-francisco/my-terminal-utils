#!/bin/zsh

dirs_file="$HOME/.dirs_stack"

if ! [[ -r $dirs_file ]]; then
	printf "\nFile %s is missing :(\n" "$dirs_file"
	return 1
fi


setopt pushd_silent   # suppress the numbering
typeset -U opts       # prevents duplicates in opts


opts=()

while IFS= read -r line; do
	opts+=("$line")
done < $dirs_file


direcs+=("${(f)$(dirs -p | cut -f2)}")


# remove current dir (the first one)
direcs=(${direcs[@]:1})


# remove the HOME
direcs=(${direcs:#\~})

opts+=( "${direcs[@]}" )



# MENU

bold='\033[1m %s\033[0m → %s\n'
bold_red='\033[1;31m %s\033[0m → %s\n'


echo
for i in {1..$#opts}; do
  idx=$((i-1))
  printf $bold_red "$idx" "${opts[i]}"
done


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






# for dir in ${(f)"$(dirs -p)"}; do
  # opts+=("$dir")
# done



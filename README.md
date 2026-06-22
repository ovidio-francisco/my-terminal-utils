# My Terminal Utils

```text
 __  __         _____                   _             _   _   _ _   _ _
|  \/  |_   _  |_   _|__ _ __ _ __ ___ (_)_ __   __ _| | | | | | |_(_) |___
| |\/| | | | |   | |/ _ \ '__| '_ ` _ \| | '_ \ / _` | | | | | | __| | / __|
| |  | | |_| |   | |  __/ |  | | | | | | | | | | (_| | | | |_| | |_| | \__ \
|_|  |_|\__, |   |_|\___|_|  |_| |_| |_|_|_| |_|\__,_|_|  \___/ \__|_|_|___/
        |___/
```



Personal command-line scripts I use to make everyday terminal work faster.

Mostly small Bash/Zsh utilities, collected here so they can be reused, changed, or moved between machines.

## Scripts

| Script            | Purpose                                            |
| ----------------- | -------------------------------------------------- |
| `bk`              | Create a timestamped backup of a file or directory |
| `clear-texfolder` | Remove LaTeX auxiliary files                       |
| `clip-menu`       | Start `clipmenu` using `rofi`                      |
| `decompress`      | Extract `.rar` and `.zip` files recursively        |
| `efind`           | Friendlier wrapper around `find`                   |
| `g`               | Jump to saved or recent directories                |
| `lt`              | Tree view with sensible defaults                   |
| `mkdirbylist`     | Create folders from a text list                    |
| `repos`           | Show status for multiple Git repositories          |
| `send-to-termbin` | Send a file to termbin                             |
| `show-md`         | Render a Markdown file as HTML                     |

## Usage

Clone the repository and add it to your `PATH`, or copy the scripts you want to use.

```bash
git clone https://github.com/ovidio-francisco/my-terminal-utils.git
```

Example:

```bash
./bk notes.txt
./lt 3
./repos -d
```

## Notes

These scripts are personal utilities, not polished CLI tools.

Read each script before running it, especially the ones that remove files.


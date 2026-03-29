# Internet Archive Collection Downloader

#### Uses: 
- Internet Archive CLI
  - Ensure you have this from: https://archive.org/developers/internetarchive/installation.html#installation
  - If you would like to install via pipx and do not have pipx, follow instructions to install pipx on your system.
- Bash

#### Ensure
- You have a collection you would like to download from
- You have a file type you would like to download (or, if you would like to download all filetypes (duplicates) and metadata, then none at all)

#### Usage
- Clone this repo to a folder you would like the folder storing the downloaded files to be in.
- Open collection-downloader.sh in a text editor, change the collection and file types accordingly.
- In the folder with the collection-downloader.sh file, in a terminal, run
  - chmod +x collection-downloader.sh   # to give the file permission to be executed
  - ./collection-downloader.sh          # to execute the file

This is a bash script that downloads items from a collection on the Internet Archive en masse, renaming then according to their metadata title and filetype. 



Use, edit, etc. with this freely. Internet Archive seems open to downloads en masse etc, however consider being mindful of bandwidth in extreme situations. If you intend to download insane amounts of data consider using their auto generated torrents. Internet Archive is a non-profit.

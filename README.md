# Spotify Music Downloader

Little bash script to download playlists from [Spotify](https://open.spotify.com/).

## Prerequisites

The script make use of the following packages:
* [jq](https://jqlang.github.io/jq/): To handle json
- [yt-dlp](https://github.com/yt-dlp/yt-dlp): to search and download music

You must install those packages in your Linux system, via package manager or directly from the repositories

## Preparation

Before download anything, it's necessary the `CLIENT_ID` and `CLIENT_SECRET` from the Spotify API, to do that follow [this tutorial](https://developer.spotify.com/documentation/web-api/tutorials/getting-started), where you basically follow the steps until you have those tokens:
1. Login into the developer webpage for spotify
1. Create an application
1. On the new application go to *Settings* and copy those values
1. Put those values in the `config` file

Give the application permissions with `chmod u+x get_playlist.sh`

## Usage

The script allows you to select a playlist for a specific user, but first you need the ID for that user, which is at the end of the spotify URL for that particular profile, copy that value and you are good to go, the script handles the rest.

**Note**: The application creates a new folder with the name of the playlist and store the music there

```bash
# Basic usage
./spoty_download.sh

# With parallelization
./spoty_download.sh 5 # Allows 5 parallel downloads
```
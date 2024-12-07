#!/usr/bin/bash

# Load the configuration
source config

# Parallelization
p=1 # Default is 1
if [[ $# -eq 1 ]]; then
        p="$1"
fi

# Get the token for the spotify API
token=$(curl -s -X POST "https://accounts.spotify.com/api/token" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "grant_type=client_credentials&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET" | jq -r '.access_token')

# Read the user ID for a spotify user

read -p "Input the user ID: " user_id

echo ""
echo "---- PLAYLISTS ----"

# Get playlists for a user
playlists=$(curl -s "https://api.spotify.com/v1/users/$user_id/playlists" \
        -H "Authorization: Bearer $token")

# Names and URLs for the playlists
names=$(echo "$playlists" | jq -r '.items[].name')
urls=$(echo "$playlists" | jq -r '.items[].tracks.href')

echo "$names" | nl

echo "---- PLAYLISTS ----"
echo ""

read -p "Select playlist number: " number

# Check errors when selecting the playlist
if [[ "$number" -gt $(echo "$names" | wc -l) || "$number" -lt 1 ]]; then
        echo "That number doesn't exists, you dumb.."
        exit 1
fi

# Get the url and the name for that particular playlist
url=$(echo "$urls" | head -n "$((number))" | tail -n 1)
folder=$(echo "$names" | head -n "$((number))" | tail -n 1)

# Get tracks for a playlist
tracks=$(curl -s "$url" \
        -H "Authorization: Bearer $token" | \
        jq -r '.items[] | "\(.track.name) " + (.track.artists | map(.name) | join(" "))')

echo ""
echo "---- TRACKS ----"
echo "$tracks"
echo "---- TRACKS ----"
echo ""

echo "$(echo "$tracks" | wc -l) tracks"
echo ""

read -p "Download all? (y/n): " download

if [[ "yes" == "$download" || "y" == "$download" ]]; then
        if [ ! -d "$folder" ]; then
                mkdir -p "$folder"
                cd "$folder"
        else
                cd "$folder"
        fi

        echo "$tracks" | xargs -I{} -P $((p)) yt-dlp -x -f bestaudio/best "ytsearch:{}"
fi
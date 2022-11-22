#!/usr/bin/env python

"""
Usage:
    cover-arts.py SPOTIFY_PLAYLIST_URL SAVE_INTO

SAVE_INTO is always relative to where cover-arts.py is.
"""

from docopt import docopt
from slugify import slugify
import requests
from helium import *
from pathlib import Path
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
from rich import print 
from dotenv import load_dotenv 

args = docopt(__doc__)
playlist_url = args["SPOTIFY_PLAYLIST_URL"]
here = Path(__file__).parent
load_dotenv(here / ".env")
save_into = here / args["SAVE_INTO"]
spotify = spotipy.Spotify(client_credentials_manager=SpotifyClientCredentials())
tracks = [t["track"] for t in spotify.playlist_tracks(playlist_url)["items"]]

def download_artwork(query, save_into):
    save_as = save_into / (slugify(query) + ".png")
    if save_as.exists():
        print(f"Skipping {save_as}, which is already downloaded")
        return
    print(f"Downloading: {query}", end=" ")
    start_chrome("https://bendodson.com/projects/itunes-artwork-finder/", headless=True)
    link = None
    try:
        entity_selector = S("#entity").web_element
        select(entity_selector, "Album")
        write(query.replace(">", " ").replace("<", " ").replace("(", " ").replace(")", " "), into=S("#query").web_element)
        click("Get the artwork")

        wait_until(lambda: not Text("Searching...").exists())

        if Text("No results found.").exists():
            kill_browser()
            print(f"[red][bold] not found on iTunes")
            return

        link = find_all(S("#results a"))[1].web_element.get_attribute("href") # first link is going to be to standard res. image of first result, second one (what we want) is high-res of first result.
    except Exception:
        print()
    finally:
        kill_browser()

    if not link:
        print(f"Couldn't get {query}'s artwork image URL")
        return 

    print(f"-> {link} -> {save_as}")
    image_response = requests.get(link)

    if image_response.status_code == 200:
        with open(str(save_as), "wb") as image_file:
            image_file.write(image_response.content)

for track in tracks:
    album = track["album"]["name"]
    artist = track["album"]["artists"][0]["name"]

    download_artwork(f"{artist} {album}", save_into)

# ls
alias cls = ls
def ls [dir = ""] { cls -s $dir | sort-by type name -i }
def la [dir = ""] { cls -s -a $dir | sort-by type name -i }
def ll [dir = ""] { cls -s -l $dir | sort-by type name -i }
def ld [dir = ""] { cls -s -d $dir | sort-by type name -i }

# video manip
def vidcompress [ in: path, out: path, level = "27" ] {
    ffmpeg -i $in -c:v libx264 -c:a aac -crf $level -preset slow $out 
}
def vidcut [ in: path, out: path, start: string, duration: string ] {
    ffmpeg -ss $start -i $in -t $duration -async 1 -vcodec copy -acodec copy $out
}

# nul
def nul [ file: path ] {
    rsync --progress $file navy:/containers/caddy/srv/file/
    echo "Link: https://file.elia.garden/$file"
    wl-copy "https://file.elia.garden/$file"
}
def nul-browse [ file: path ] {
    rsync --progress $file navy:/containers/caddy/srv/browse/
    echo "Link: https://browse.elia.garden/$file"
    wl-copy "https://browse.elia.garden/$file"
}

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

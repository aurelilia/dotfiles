lf () {
	LF_TEMPDIR="$(mktemp -d -t lf-tempdir-XXXXXX)"
	LF_TEMPDIR="$LF_TEMPDIR" lf-run -last-dir-path="$LF_TEMPDIR/lastdir" "$@"
	if [ "$(cat "$LF_TEMPDIR/cdtolastdir" 2>/dev/null)" = "1" ]; then
		cd "$(cat "$LF_TEMPDIR/lastdir")"
	fi
	rm -r "$LF_TEMPDIR"
	unset LF_TEMPDIR
}

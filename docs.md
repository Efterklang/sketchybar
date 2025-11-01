## Q&A

### media control

Recommend using `media-control` in `settings.lua` which has better compatibility with MacOS.

If you use `mpc` + `mpc`(or any other client), you may not be able to switch songs out of the box since mpd hasn't implment MacOS media control api.

This could be fixed by install `mpd-now-playable`, which will sync mpd status to MacOS media control api.

```shell
brew install pipx
pipx install mpd-now-playable
zsh -lc "mpd-now-playable > /dev/null 2>&1 &"  # run it in background
```

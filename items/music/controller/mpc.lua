local MPC = {}

-- #region Control Functions
-- 这部分函数用于控制mpc播放器的行为
function MPC.next_track()
  SBAR.exec("mpc next")
end

function MPC.prev_track()
  SBAR.exec("mpc prev")
end

function MPC.toggle_play()
  SBAR.exec("mpc toggle")
end

function MPC.toggle_shuffle()
  SBAR.exec("mpc random")
end

function MPC.toggle_repeat()
  SBAR.exec("mpc repeat")
end

-- #endregion Control Functions

-- #region Info Updaters
-- Function in this section fetches information from mpc and passes it to the provided callback functions.
-- The callbacks are responsible for updating the UI using sketchybar's API.
-- 这部分函数可以传入callback function, 函数内将mpc的信息传递给callback,
-- 由callback调用sketchybar的API更新UI
function MPC.stats(callback)
  -- 检查 is_playing, is_repeat, is_shuffle
  SBAR.exec("mpc status", function(result)
    local is_playing = result:match("%[playing%]") ~= nil
    local is_repeat = result:match("repeat: on") ~= nil
    local is_shuffle = result:match("random: on") ~= nil
    callback(is_playing, is_repeat, is_shuffle)
  end)
end

function MPC.update_current_track(callback)
  SBAR.exec("mpc current -f '%title%;%artist%;%album%;'", function(info)
    local title, artist, album = info:match("([^;]*);([^;]*);([^;]*)")
    callback(title, artist, album)
  end)
end

function MPC.update_album_art(callback)
  local size = MUSIC.ALBUM_ART_SIZE
  local cmd = string.format(
    'mpc readpicture "$(mpc current -f %%file%%)" > /tmp/music_cover.jpg && sips -z %d %d /tmp/music_cover.jpg',
    size,
    size
  )
  SBAR.exec(cmd, function()
    callback("/tmp/music_cover.jpg")
  end)
end

-- #endregion Info Updaters

return MPC

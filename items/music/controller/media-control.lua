local media_control = {}

-- #region Control Functions
-- 这部分函数用于控制media-control播放器的行为
function media_control.next_track()
  SBAR.exec("media-control next-track")
end

function media_control.prev_track()
  SBAR.exec("media-control previous-track")
end

function media_control.toggle_play()
  SBAR.exec("media-control toggle-play-pause")
end

function media_control.toggle_shuffle()
  SBAR.exec("media-control toggle-shuffle")
end

function media_control.toggle_repeat()
  SBAR.exec("media-control toggle-repeat")
end

-- #endregion Control Functions

-- #region Info Updaters
function media_control.stats(callback)
  -- 使用 media-control get 获取播放状态
  SBAR.exec("media-control get -h", function(result)
    -- Note: media-control get 不提供 repeat 和 shuffle 信息
    -- 如果需要这些信息，可能需要使用其他命令或保持原有实现
    callback(result.playing, false, false)
  end)
end

function media_control.update_current_track(callback)
  SBAR.exec("media-control get -h", function(result)
    callback(result.title, result.artist, result.album)
  end)
end

function media_control.update_album_art(callback)
  -- 使用 media-control get 获取封面数据并保存到文件
  local size = MUSIC.ALBUM_ART_SIZE
  local cmd = string.format(
    'media-control get | jq -r ".artworkData" | base64 -d > /tmp/music_cover.jpg 2>/dev/null && sips -z %d %d /tmp/music_cover.jpg',
    size,
    size
  )
  SBAR.exec(cmd, function()
    callback("/tmp/music_cover.jpg")
  end)
end

-- #endregion Info Updaters

return media_control

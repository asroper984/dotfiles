# Sway Screenshot Configuration Fix

## Goal

Fix the screenshot keybindings in `~/.config/sway/config` so that screenshots are correctly saved to file and copied to clipboard.

## Problem

The current configuration uses `exec` with a pipeline (`|`). While `sway` supports this, complex pipelines involving command substitutions `$(...)` and pipes are often more reliable when explicitly wrapped in a shell (`sh -c`). additionally, the "Save to file" command fails silently if the destination directory `~/Pictures/Screenshots` does not exist.

## Proposed Changes

We will modify the keybindings to:

1.  Wrap the commands in `sh -c '...'` to ensure the pipeline is executed correctly by a shell.
2.  Add `mkdir -p ~/Pictures/Screenshots` to the save command to ensure the directory exists before saving.
3.  Use a slightly more robust syntax for `slurp` to handle potential cancellations gracefully (though the primary fix is the pipe/directory).

### `~/.config/sway/config`

We interpret the user's snippet as lines 91-97.

#### [MODIFY] config

```sway
# Screenshotting

# Copy to clipboard
# Old: bindsym $mod_1+z exec grim -g "$(slurp)" - | wl-copy
# New: Explicitly use sh -c to handle the pipe
bindsym $mod_1+z exec sh -c 'grim -g "$(slurp)" - | wl-copy'

# Save to file
# Old: bindsym $mod_1+x exec grim -g "$(slurp)" - | tee ~/Pictures/Screenshots/$(date +"%Y-%m-%d_%H-%M-%S").png
# New: Create directory first, then screenshot
bindsym $mod_1+x exec sh -c 'mkdir -p ~/Pictures/Screenshots && grim -g "$(slurp)" - > ~/Pictures/Screenshots/$(date +"%Y-%m-%d_%H-%M-%S").png'
```

> [!NOTE]
> Ensure that `grim`, `slurp`, and `wl-copy` are installed on your system. You can check this by running `which grim slurp wl-copy` in your terminal.
> Also verify if `$mod_1` is indeed your intended modifier variable (usually it is `$mod`, but `$mod_1` is valid if defined).

## Verification Plan

### Manual Verification

1.  Reload sway config: `swaymsg reload`
2.  Press `$mod_1+z`, select an area. Paste into an image viewer or browser to verify clipboard.
3.  Press `$mod_1+x`, select an area. Check `~/Pictures/Screenshots` for the new file.

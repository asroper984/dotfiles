
import os

path = "/home/arope/.config/sway/config"
with open(path, 'r') as f:
    lines = f.readlines()

# Ensure we are editing the right lines by simple check (optional but good for safety)
# Line 94 is index 93
if "bindsym $mod_1+z" in lines[93]:
    lines[93] = "bindsym $mod_1+z exec sh -c 'grim -g \"$(slurp)\" - | wl-copy'\n"
else:
    print(f"Warning: Line 94 unexpected: {lines[93]}")

# Line 96 is index 95
if "bindsym $mod_1+x" in lines[95]:
    lines[95] = "bindsym $mod_1+x exec sh -c 'mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" - > ~/Pictures/Screenshots/$(date +\"%Y-%m-%d_%H-%M-%S\").png'\n"
else:
    print(f"Warning: Line 96 unexpected: {lines[95]}")

with open(path, 'w') as f:
    f.writelines(lines)

print("Config updated successfully.")

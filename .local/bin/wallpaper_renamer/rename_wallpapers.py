#!/usr/bin/env python3
import os
import uuid
from pathlib import Path

def rename_wallpapers():
    # Define the target directory
    target_dir = Path("~/.local/share/wallpapers").expanduser()

    # Check if directory exists
    if not target_dir.exists():
        print(f"Error: Directory not found at {target_dir}")
        return

    # Gather all files (ignoring subdirectories)
    files = [f for f in target_dir.iterdir() if f.is_file()]
    
    # Sort files to ensure a deterministic order (alphabetical by original name)
    files.sort(key=lambda f: f.name)

    print(f"Found {len(files)} files. Starting rename process...")

    # Step 1: Rename all files to a temporary random name.
    # This prevents collisions (e.g., if 'bg1.png' already exists and we try to rename another file to 'bg1.png').
    temp_files = []
    for f in files:
        ext = f.suffix # Keeps the original extension
        temp_name = target_dir / f"temp_{uuid.uuid4().hex}{ext}"
        try:
            f.rename(temp_name)
            temp_files.append(temp_name)
        except Exception as e:
            print(f"Failed to create temp file for {f.name}: {e}")

    # Step 2: Rename temporary files to the final bg(number) format
    count = 1
    for f in temp_files:
        ext = f.suffix
        new_name = target_dir / f"bg{count}{ext}"
        try:
            f.rename(new_name)
            print(f"Renamed: {new_name.name}")
            count += 1
        except Exception as e:
            print(f"Error renaming temp file {f.name} to final name: {e}")

    print("Renaming complete.")

if __name__ == "__main__":
    rename_wallpapers()

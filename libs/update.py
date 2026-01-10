import os
import sys
import urllib.request
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
VERSION_FILE = SCRIPT_DIR / ".version"

UPDATE_URL = "https://raw.githubusercontent.com/whentheh-yt/Molvolution/main/libs/.version"

def read_current_version():
    try:
        with open(VERSION_FILE, 'r') as f:
            version = f.read().strip()
            print(f"Found version: {version}")
            return version
    except FileNotFoundError:
        print(f"ERROR: .version file not found!")
        print(f"Expected location: {VERSION_FILE}")
        print(f"Current working directory: {os.getcwd()}")
        return None

def check_remote_version():
    try:
        print("\nChecking for updates...")
        with urllib.request.urlopen(UPDATE_URL, timeout=5) as response:
            return response.read().decode('utf-8').strip()
    except Exception as e:
        print(f"Error checking for updates: {e}")
        return None

def compare_versions(current, remote):
    return current != remote

def main():
    print("=" * 60)
    print("Molvolution Update Manager")
    print("=" * 60)
    print()
    
    current = read_current_version()
    if not current:
        input("\nPress Enter to exit...")
        return
    
    print(f"\nCurrent version: {current}")
    
    remote = check_remote_version()
    
    if not remote:
        print("\nLocal version check complete.")
        print("Remote update checking not configured yet.")
        input("\nPress Enter to exit...")
        return
    
    print(f"Latest version:  {remote}")
    
    if compare_versions(current, remote):
        print("\n" + "=" * 60)
        print("UPDATE AVAILABLE!")
        print("=" * 60)
        print("\nPlease visit your download page to get the latest version.")
        print("\nDownload page: https://www.github.com/whentheh-yt/Molvolution")
    else:
        print("\n✓ You're up to date!")
    
    input("\nPress Enter to exit...")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nCancelled by user")
        sys.exit(1)
    except Exception as e:
        print(f"\nUnexpected error: {e}")
        import traceback
        traceback.print_exc()
        input("\nPress Enter to exit...")
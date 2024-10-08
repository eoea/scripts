#!/usr/bin/env python3
import os
import site
import subprocess

# Program that ctags the Python standard library.


def main():
    scripts_path: str = os.path.join(os.environ.get("MYSCRIPTS"), "tag")
    prog_path: str = os.path.join(os.getcwd(), "tag.py")
    is_initial_run: bool = False

    # This is only needed if the script `tag.py` is not in ~/.local/scripts/tag
    if not os.path.isfile(scripts_path):
        subprocess.run(
            ["ln", "-sfv", prog_path, scripts_path], capture_output=True, text=True
        )
        print("Success: Symlink created.")
        is_initial_run = True

    py_module_path: str = site.getsitepackages()[0]
    cmd = subprocess.run(
        ["ctags", "-R", "--languages=Python", py_module_path],
        capture_output=True,
        text=True,
    )

    if cmd.stderr:
        print("Error: ", cmd.stderr)
    else:
        print("Success: Python tags created.")
        if is_initial_run:
            os.remove("tags")


if __name__ == "__main__":
    main()

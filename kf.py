#!/usr/bin/env python3
"""
kf prints file and line information for all locations where keyword
tags are found.
"""
import os
import argparse

CHAR_COUNT = 65
KEYWORDS = [
    "@TODO",
    "@NOTE",
    "@DBUGR",
    "@BUG",
    "@FEAT",
    "@FEATURE",
    "@REFACT",
    "@REFACTOR",
    "@FOLLOWUP",
]


def count_occurrence(file: str) -> None:
    with open(file, "r") as f:
        i = 0
        for line in f:
            for word in KEYWORDS:
                if word in line:
                    print(
                        f"{file}: {i}: \033[33m{line.strip():.{CHAR_COUNT}}...\033[0m"
                    )
                    break
            i += 1


def count_occurrence_in_all_files(path: str) -> None:
    if not os.path.isfile(path):
        for dir_content in os.listdir(path):
            if os.path.isfile(dir_content):
                try:
                    count_occurrence(os.path.join(path, dir_content))
                except:
                    pass
            else:
                count_occurrence_in_all_files(os.path.join(path, dir_content))
    else:
        try:
            count_occurrence(
                path
            )  # @NOTE(eoea): No need to do `os.path.join(path, dir_content)` because this is path is already set to this.
        except:
            pass


def main() -> None:
    count_occurrence_in_all_files(os.path.realpath("."))


if __name__ == "__main__":
    main()

from dataclasses import dataclass
import subprocess
from typing import List


def print_warning_message(message: str) -> None:
    print("\033[93m" + message + "\033[0m")


@dataclass
class Crime:
    pattern: str  # Search pattern
    directory: str  # directory where the search should take place
    message: str  # Message to display when a crimes is found
    excluded_files: List[str]  # Files to be excluded from the search


CRIMES = [
    Crime(
        pattern="apps",
        directory=".",
        message="please do not use the word 'apps'",
        excluded_files=[""],
    ),
]


def detect_crimes() -> bool:
    success = True
    for crime in CRIMES:
        result = subprocess.run(
            f"ag {crime.pattern} {crime.directory} -l",
            shell=True,
            capture_output=True,
        )
        # print(result.stdout, result.stderr)
        if result.returncode == 0:
            matched_files = result.stdout.decode("utf-8").strip().split("\n")
            violation_files = sorted(
                set(matched_files) - set(crime.excluded_files or [])
            )
            if violation_files:
                print(f"Found crime pattern '{crime.pattern}' in {violation_files}")
                print_warning_message(crime.message)
                print()
                success = False

    return success


def main() -> int:
    success = detect_crimes()
    return 0 if success else 1

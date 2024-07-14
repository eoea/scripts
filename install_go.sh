#!/usr/bin/env bash
#
# This program is a script that downloads and installs Go
# for the correct OS and architecture.
#
# It is better to download the latest version of Go or a version
# of Go that is one before the current. The older versions of
# Go are with a different link that isn't supported with this
# program.
#
# Created by Emile O.E. Antat (eoea) <eoea754@gmail.com>
set -e

usage() {
	echo "${0} is a shell script that downloads and installs Go "
	echo "for the correct OS and architecture. "
	echo
	echo "Usage:"
	echo
	echo "        ${0} [flags]"
	echo
	echo "The flags are:"
	echo
	echo "        -h         Show help."
	echo "        -v         To specify the version, default is 1.22.5"
	echo
	echo "Examples:"
	echo
	echo "        ${0} "
	echo "        ${0} -v 1.22.5"
	echo
}

######################################
# Downloads the version of Go based on the operating
# system and architecture. Uses curl.
#
# On MacOS only the arm version of Go is installed.
# On Linux arm or x86 are installed depending on the architecture.
#
# Arguments:
#   version: The version number for Go to download
#
# Return:
#   - The name of the downlaoded file. Or:
#   - (Return 1 if a Kernel is neither Darwin nor Linux)
######################################
download() {
	local version
	version="${*}"

	case "$(uname -s)" in
	Linux)
		if [[ "$(uname -m)" == "aarch64" ]]; then
			url="https://go.dev/dl/go${version}.linux-arm64.tar.gz"
		elif [[ "$(uname -m)" == "x86_64" ]]; then
			url="https://go.dev/dl/go${version}.linux-amd64.tar.gz"
		fi
		;;
	Darwin)
		if [[ "$(uname -m)" == "arm64" ]]; then
			url="https://go.dev/dl/go${version}.darwin-arm64.tar.gz"
		fi
		;;
	*)
		echo "No download for $(uname -s) $(uname -m)" >&2
		return 1
		;;
	esac

	cd "${HOME}/Downloads"
	curl -LO "${url}"

	echo "${url}" | awk -F/ '{ print $5 }'
}

main() {
	local version
	local url
	local exit_code=0

	version="1.22.5"

	while getopts "hv:" flags; do
		case "${flags}" in
		h)
			usage
			exit_code=1
			;;
		v)
			version="${OPTARG}"
			;;
		*)
			echo "Error: invalid flag, use ${0} -h for help." >&2
			exit_code=1
			;;
		esac
	done

	if [[ "${exit_code}" == 1 ]]; then
		return "${exit_code}"
	fi

	mkdir -p "${HOME}/Downloads"

	local file_name
	file_name="$(download "${version}")"

	if [[ -f "${HOME}/Downloads/${file_name}" ]]; then
			rm -rf "${HOME}/.local/bin/go" && tar -C "${HOME}/.local/bin" -xzf "${HOME}/Downloads/${file_name}"
	else
		exit_code=1
		echo "Error: during the file download." >&2
	fi

	return "${exit_code}"
}

main "$@"

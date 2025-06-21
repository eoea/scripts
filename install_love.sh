#!/usr/bin/env bash
#
# This is a script that downloads and installs Love2d on MacOS.
#
# Created by Emile O.E. Antat (eoea) <eoea754@gmail.com>

main() {
	local url
	local version

	version=11.5

	case "$(uname -s)" in
	Darwin)
		if [[ "$(uname -m)" == "arm64" ]]; then
			url="https://github.com/love2d/love/releases/download/${version}/love-${version}-macos.zip"
			curl -L "${url}" -o "${HOME}/Downloads/love.zip"
			unzip -o "${HOME}/Downloads/love.zip" -d "${HOME}/Applications"
			ln -sfv "${HOME}/Applications/love.app/Contents/MacOS/love" "${HOME}/.local/bin/love"
		fi
		;;
	*)
		echo "No download for $(uname -s) $(uname -m)" >&2
		return 1
		;;
	esac

}

main "$@"

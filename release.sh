#!/bin/bash

if [ -z "${GITDIR}" ]; then
	echo "Please specify the 'GITDIR' environment variable."
	exit 1
fi

cd "${GITDIR}"
git rev-parse HEAD > ./.commit
chmod u+s "${GITDIR}/bin/busybox"
find . -type f -name ".gitkeep" -exec rm {} \;
rm -f ../gui_rootfs.isa
mksquashfs . ../gui_rootfs.isa -b 1048576 -comp xz -Xdict-size 100% -always-use-fragments -all-root -e .git -e .gitignore -e .vscode -e release.sh
rm ./.commit
find . -type d ! -path "*.git*" -empty -exec touch '{}'/.gitkeep \;
echo "gui-rootfs filesystem has been compressed."


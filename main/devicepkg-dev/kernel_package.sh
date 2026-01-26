#!/bin/sh

# Parse arguments
builddir=$1
pkgdir=$2
_carch=$3
_flavor=$4
_outdir=$5

if [ -z "$builddir" ] || [ -z "$pkgdir" ] || [ -z "$_carch" ] ||
	[ -z "$_flavor" ]; then
	echo "ERROR: missing argument!"
	echo "Please call kernel_package() with \$builddir, \$pkgdir,"
	echo "\$_carch, \$_flavor (and optionally \$_outdir) as arguments."
	exit 1
fi

# Downstream kernel install
if [ "$DOWNSTREAM" -eq 1 ]; then
	# kernel.release
	install -D "$builddir/$_outdir/include/config/kernel.release" \
		"$pkgdir/usr/share/kernel/$_flavor/kernel.release"

	# zImage (find the right one)
	# shellcheck disable=SC2164
	cd "$builddir/$_outdir/arch/$_carch/boot"
	_target="$pkgdir/boot/vmlinuz"

	if [ -n "$KERNEL_IMAGE_NAME" ]; then
		if ! [ -e "$KERNEL_IMAGE_NAME" ]; then
			echo "Could not find \$KERNEL_IMAGE_NAME in $PWD!"
			exit 1
		else
			echo "NOTE: using $KERNEL_IMAGE_NAME as kernel image."
			install -Dm644 "$KERNEL_IMAGE_NAME" "$_target"
		fi
	else
		for _zimg in zImage-dtb Image.gz-dtb *zImage Image; do
			[ -e "$_zimg" ] || continue
			echo "zImage found: $_zimg"
			install -Dm644 "$_zimg" "$_target"
			break
		done
		if ! [ -e "$_target" ]; then
			echo "Could not find zImage in $PWD!"
			exit 1
		fi
	fi
# Mainline kernel install
else
	case "$_carch" in
			arm*|riscv*) _install="zinstall dtbs_install" ;;
			*) _install="install" ;;
	esac

	make modules_install "$_install" \
		ARCH="$_carch" \
		LLVM=1 \
		INSTALL_PATH="$pkgdir"/boot/ \
		INSTALL_MOD_PATH="$pkgdir"/usr \
		INSTALL_MOD_STRIP=1 \
		INSTALL_DTBS_PATH="$pkgdir"/boot/dtbs-"$_flavor"

	rm -f "$pkgdir"/usr/lib/modules/*/build "$pkgdir"/usr/lib/modules/*/source

	install -D "$builddir"/include/config/kernel.release \
		"$pkgdir"/usr/share/kernel/"$_flavor"/kernel.release
fi

echo "Checking if eMMC is present..."

mmc dev 1

if mmc rescan ; then
        setenv bootdevice "/dev/mmcblk1p2"
        echo "eMMC device is present, root=$bootdevice"
else
        setenv bootdevice "/dev/mmcblk0p2"
        echo "eMMC device is NOT present, root=$bootdevice"
fi

setenv bootargs "root=$bootdevice rw rootwait console=ttySAC2,115200n8 consoleblank=0"
setenv bootcmd "fatload mmc 0:1 40008000 zImage; fatload mmc 0:1 46000000 exynos5422-odroidxu3.dtb; bootz 40008000 - 46000000"

boot

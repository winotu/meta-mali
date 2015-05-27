inherit image_types

IMAGE_DEPENDS_sdcard = "parted-native:do_populate_sysroot \
                        dosfstools-native:do_populate_sysroot \
                        mtools-native:do_populate_sysroot \
                        virtual/kernel:do_deploy \
                        u-boot:do_deploy"

SDCARD = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.sdcard"

SDCARD_GENERATION_COMMAND_odroidxu3 = "generate_odroidxu3_sdcard"

BOOT_SPACE ?= "12288"
IMAGE_ROOTFS_ALIGNMENT = "4096"

IMAGE_CMD_sdcard () {
	if [ -z "${SDCARD_ROOTFS}" ]; then
		bberror "SDCARD_ROOTFS is undefined."
		exit 1
	fi

	${SDCARD_GENERATION_COMMAND}
}

generate_odroidxu3_sdcard () {
	BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
	BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE_ALIGNED} - ${BOOT_SPACE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})

	ROOTFS_SIZE=`du -bks ${SDCARD_ROOTFS} | awk '{print $1}'`
	ROOTFS_SIZE_ALIGNED=$(expr ${ROOTFS_SIZE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
	ROOTFS_SIZE_ALIGNED=$(expr ${ROOTFS_SIZE_ALIGNED} - ${ROOTFS_SIZE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})

	SDCARD_SIZE=$(expr ${IMAGE_ROOTFS_ALIGNMENT} + ${BOOT_SPACE_ALIGNED} + ${ROOTFS_SIZE_ALIGNED})
	dd if=/dev/zero of=${SDCARD} bs=1024 count=0 seek=${SDCARD_SIZE}

	parted -s ${SDCARD} mktable msdos
	parted -s ${SDCARD} unit KiB mkpart primary ${IMAGE_ROOTFS_ALIGNMENT} $(expr ${BOOT_SPACE_ALIGNED} \+ ${IMAGE_ROOTFS_ALIGNMENT})
	parted -s ${SDCARD} -- unit KiB mkpart primary $(expr ${BOOT_SPACE_ALIGNED} \+ ${IMAGE_ROOTFS_ALIGNMENT}) -1s

	# Create boot partition image
	BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDCARD} unit b print | awk '/ 1 / { print substr($4, 1, length($4 -1)) / 1024 }')
	mkfs.vfat -S 512 -C ${WORKDIR}/boot.img $BOOT_BLOCKS
	mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${MACHINE}.bin ::/${KERNEL_IMAGETYPE}
	mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${KERNEL_DEVICETREE} ::/${KERNEL_DEVICETREE}
	mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/boot.scr ::/boot.scr

	dd if=${DEPLOY_DIR_IMAGE}/bl1.bin.hardkernel of=${SDCARD} conv=notrunc seek=1
	dd if=${DEPLOY_DIR_IMAGE}/bl2.bin.hardkernel of=${SDCARD} conv=notrunc seek=31
	dd if=${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.${UBOOT_SUFFIX} of=${SDCARD} conv=notrunc seek=63
	dd if=${DEPLOY_DIR_IMAGE}/tzsw.bin.hardkernel of=${SDCARD} conv=notrunc seek=719

	dd if=${WORKDIR}/boot.img of=${SDCARD} conv=notrunc seek=1 bs=$(expr ${IMAGE_ROOTFS_ALIGNMENT} \* 1024) && sync && sync
	dd if=${SDCARD_ROOTFS} of=${SDCARD} conv=notrunc seek=1 bs=$(expr ${BOOT_SPACE_ALIGNED} \* 1024 + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024) && sync && sync
}

IMAGE_TYPEDEP_sdcard = "${@d.getVar('SDCARD_ROOTFS', 1).split('.')[-1]}"

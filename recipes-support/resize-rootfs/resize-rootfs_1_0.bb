RDEPENDS_${PN} = "parted e2fsprogs"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${MALIBASE}/COPYING.MIT;md5=838c366f69b72c5df05c96dff79b35f2"

SRC_URI = " \
	file://resize-rootfs \
	file://resize-status \
"

do_configure() {
	:
}

do_compile() {
	:
}

do_install() {
	install -d ${D}/${sbindir}
	install -d ${D}/${sysconfdir}
	install -m 0755 ${WORKDIR}/resize-rootfs ${D}/${sbindir}
	install -m 0755 ${WORKDIR}/resize-status ${D}/${sysconfdir}
}

FILES_${PN} = "${sbindir}/resize-rootfs ${sysconfdir}/resize-status"

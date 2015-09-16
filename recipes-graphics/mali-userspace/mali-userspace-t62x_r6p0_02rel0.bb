require mali-userspace.inc

TYPE = "mali-t62x"

SRC_URI = "${MALI_URI}/${PV}-${PR}/${TYPE}_${PV}-${PR}_linux_1+fbdev.tar.gz;name=fbdev \
	 ${MALI_URI}/${PV}-${PR}/${TYPE}_${PV}-${PR}_linux_1+x11.tar.gz;name=x11"

SRC_URI[fbdev.md5sum] = "1275f58128dbec35cc1a5b761fe8b601"
SRC_URI[fbdev.sha256sum] = "39ba3cc89d6954630aa0a863d310f1a4e51d48df7c4cda4cff7dbeab94540dcc"
SRC_URI[x11.md5sum] = "d20ffc063fcb464f531e69621814b6d2"
SRC_URI[x11.sha256sum] = "89f0943fb8f6046e6f3b12a8013c301c0f138ab00f81ba19b1c284a037f103ba"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://END_USER_LICENCE_AGREEMENT.txt;md5=91ae802bfcae6f13f66c45c069b00cb1"

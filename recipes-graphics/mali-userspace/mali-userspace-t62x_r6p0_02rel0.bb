require mali-userspace.inc

TYPE = "mali-t62x"

SRC_URI = "${MALI_URI}/${PV}-${PR}/${TYPE}_${PV}-${PR}_linux_1+fbdev.tar.gz;name=fbdev \
	 ${MALI_URI}/${PV}-${PR}/${TYPE}_${PV}-${PR}_linux_1+x11.tar.gz;name=x11"

SRC_URI[fbdev.md5sum] = "2df8de2bb61aae7efa857b83aa4e610e"
SRC_URI[fbdev.sha256sum] = "1403f90487e3336a26bed11dfa5489ac8e3ce542e236516785d354dda8a265c0"
SRC_URI[x11.md5sum] = "e02baf8c6846120e0bd07139f7745c3c"
SRC_URI[x11.sha256sum] = "33de642dc7f365f1e7b82f956f706f9f75b7276ee742dc1aca0069053244f100"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://END_USER_LICENCE_AGREEMENT.txt;md5=6c3209233a1523d6c38e3c188ec54e70"

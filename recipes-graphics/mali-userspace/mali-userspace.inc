LICENSE = "Proprietary"
SECTION = "libs"

PROVIDES += "virtual/egl virtual/libgles1 virtual/libgles2 virtual/libopencl"

S = "${WORKDIR}"

MALI_URI = "http://malideveloper.arm.com/downloads/drivers/binary"

RDEPENDS_${PN} += "kernel-module-mali-kbase"

INSANE_SKIP_${PN} = "ldflags dev-so"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

inherit mali_eula_unpack

USE_X11 = "${@base_contains("DISTRO_FEATURES", "x11", "yes", "no", d)}"
USE_DFB = "${@base_contains("DISTRO_FEATURES", "directfb", "yes", "no", d)}"
USE_WL = "${@base_contains("DISTRO_FEATURES", "wayland", "yes", "no", d)}"

do_install () {
	# Create MALI manifest
	install -d ${D}/${sysconfdir}
	install -d ${D}/${libdir}
	if [ "${USE_X11}" = "yes" ]; then
		install ${S}/x11/libmali.so ${D}/${libdir}
	else
		install ${S}/fbdev/libmali.so ${D}/${libdir}
	fi

	ln -sf libmali.so ${D}/${libdir}/libEGL.so
	ln -sf libmali.so ${D}/${libdir}/libGLESv1_CM.so
	ln -sf libmali.so ${D}/${libdir}/libGLESv2.so
	ln -sf libmali.so ${D}/${libdir}/libOpenCL.so
}


PACKAGES = "${PN}"
FILES_${PN} += "${sysconfdir}/MALI_MANIFEST \
		${libdir}/*.so "

RREPLACES_${PN} = "libegl libegl1 libgles1 libglesv1-cm1 libgles2 libglesv2-2 libopencl"
RPROVIDES_${PN} = "libegl libegl1 libgles1 libglesv1-cm1 libgles2 libglesv2-2 libopencl"
RCONFLICTS_${PN} = "libegl libegl1 libgles1 libglesv1-cm1 libgles2 libglesv2-2 libopencl"

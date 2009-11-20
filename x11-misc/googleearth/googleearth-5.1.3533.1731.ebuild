# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-misc/googleearth/googleearth-5.1.3533.1731.ebuild 2009/11/20 02:36:25 Exp $

EAPI=2

inherit eutils fdo-mime versionator toolchain-funcs

DESCRIPTION="A 3D interface to the planet"
HOMEPAGE="http://earth.google.com/"
# no upstream versioning, version determined from help/about
# incorrect digest means upstream bumped and thus needs version bump
SRC_URI="http://dl.google.com/earth/client/current/GoogleEarthLinux.bin
			-> GoogleEarthLinux-${PV}.bin"

LICENSE="googleearth MIT X11 SGI-B-1.1 openssl as-is ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror strip"
IUSE="+curl +mesa +qt4 gdal nss_mdns"

GCC_NEEDED="4.2"

RDEPEND=">=sys-devel/gcc-${GCC_NEEDED}[-nocxx]
	x86? (
		media-libs/fontconfig
		media-libs/freetype
		virtual/opengl
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXext
		x11-libs/libXrender
		x11-libs/libXau
		x11-libs/libXdmcp
		sys-libs/zlib
		dev-libs/glib:2
	)
	amd64? (
		app-emulation/emul-linux-x86-xlibs
		app-emulation/emul-linux-x86-baselibs
		|| (
			>=app-emulation/emul-linux-x86-xlibs-7.0
			x11-drivers/nvidia-drivers
			<x11-drivers/ati-drivers-8.28.8
		)
	)
	media-fonts/ttf-bitstream-vera
	curl? ( >=net-misc/curl-7 )
	mesa? ( >=media-libs/mesa-7 )
	qt4? ( x11-libs/qt-core:4
			x11-libs/qt-gui:4
			x11-libs/qt-webkit:4 )
	gdal? ( sci-libs/gdal )"

S="${WORKDIR}"

QA_TEXTRELS="opt/googleearth/libgps.so
opt/googleearth/libgooglesearch.so
opt/googleearth/libevll.so
opt/googleearth/librender.so
opt/googleearth/libinput_plugin.so
opt/googleearth/libflightsim.so
opt/googleearth/libcollada.so
opt/googleearth/libminizip.so
opt/googleearth/libauth.so
opt/googleearth/libbasicingest.so
opt/googleearth/libmeasure.so
opt/googleearth/libgoogleearth_lib.so
opt/googleearth/libmoduleframework.so
"

QA_DT_HASH="opt/${PN}/.*"

LANGS="ad ae af ag ai al am an ao aq ar as at au aw ax az ba bb bd be bf bg bh bi bj bm bn bo br bs bt bv bw by bz ca cc cd cf cg ch ci ck cl cm cn co cr cs cu cv cx cy cz da de dj dk dm do dz ec ee eg eh el er es et fi fil fj fk fm fo fr ga gb gd ge gf gg gh gi gl gm gn gp gq gr gs gt gu gw gy he hi hk hm hn hr ht hu id ie il im in io iq ir is it ja je jm jo jp ke kg kh ki km kn ko kp kr kw ky kz la lb lc li lk lr ls lt lu lv ly ma mc md me mg mh mk ml mm mn mo mp mq mr ms mt mu mv mw mx my mz na nc ne nf ng ni nl no np nr nu nz om pa pe pf pg ph pk pl pm pn pr ps pt-PT pt pw py qa re ro rs ru rw sa sb sc sd se sg sh si sj sk sl sm sn so sr st sv sy sz tc td tf tg th tj tk tl tm tn to tr tt tv tw tz ua ug uk um uy uz va vc ve vg vi vn vu wf ws ye yt za zh-Hans zh-Hant zm zw"
for lng in ${LANGS} ; do
	IUSE="${IUSE} linguas_${lng}"
done

pkg_setup() {
	GCC_VER="$(gcc-version)"
	if ! version_is_at_least ${GCC_NEEDED} ${GCC_VER}; then
		ewarn "${PN} needs libraries from gcc-${GCC_NEEDED} or higher to run"
		ewarn "Your active gcc version is only ${GCC_VER}"
		ewarn "Please consult the GCC upgrade guide to set a higher version:"
		ewarn "http://www.gentoo.org/doc/en/gcc-upgrading.xml"
	fi
}

src_unpack() {
	unpack_makeself
}

src_prepare() {
	# make the postinst script only create the files; it's  installation
	# are too complicated and inserting them ourselves is easier than
	# hacking around it
	sed -i -e 's:$SETUP_INSTALLPATH/::' \
		-e 's:$SETUP_INSTALLPATH:1:' \
		-e "s:^xdg-desktop-icon.*$::" \
		-e "s:^xdg-desktop-menu.*$::" \
		-e "s:^xdg-mime.*$::" postinstall.sh
}

src_install() {
	make_wrapper ${PN} ./${PN} /opt/${PN} . || die "make_wrapper failed"
	./postinstall.sh
	insinto /usr/share/mime/packages
	doins ${PN}-mimetypes.xml
	domenu Google-${PN}.desktop
	doicon ${PN}-icon.png
	dodoc README.linux

	cd bin
	tar xf "${WORKDIR}"/${PN}-linux-x86.tar
	exeinto /opt/${PN}
	doexe *

	cd "${D}"/opt/${PN}
	tar xf "${WORKDIR}"/${PN}-data.tar

	fowners -R root:root /opt/${PN}
	fperms -R a-x,a+X /opt/googleearth/resources

	# shared curl lib
	if use curl ; then
		rm -rvf libcurl.so.4
	fi
	# shared mesa lib
	if use mesa ; then
		rm -rvf libGLU.so.1
	fi
	# shared qt4 libs
	if use qt4 ; then
		local i
		for i in libQtCore.so.4 libQtNetwork.so.4 libQtGui.so.4 plugins libQtWebKit.so.4 ; do
			rm -rvf "${i}"
		done
	fi
	# shared gdal & proj libs
	if use gdal ; then
		rm -rvf libgdal.so.1 libproj.so.0
	fi
	# shared nss_mdns lib
	if use nss_mdns ; then
		rm -rvf libnss_mdns4_minimal.so.2
	fi
	# delete qt.conf
	rm -rvf qt.conf
}

pkg_preinst() {
	#deleting unused lang files & dirs
	for lng in ${LANGS} ; do
		if ! use linguas_${lng} ; then
			if [[ ${lng} = "es" ]] ; then
				rm -vf ${D}/opt/${PN}/lang/${lng}*.qm
			else
				if [[ -f ${D}/opt/${PN}/lang/${lng}.qm ]] ; then
					rm -vf ${D}/opt/${PN}/lang/${lng}.qm
				fi
			fi
			local i
			for i in country locale ; do
				if [[ ${lng} = "es" ]] ; then
						rm -vf ${D}/opt/${PN}/resources/${lng}*.${i}
						rm -rvf ${D}/opt/${PN}/resources/${lng}*.${i}
				else
					if [[ -f ${D}/opt/${PN}/resources/${lng}.${i} ]] ; then
						rm -vf ${D}/opt/${PN}/resources/${lng}.${i}
					fi
					if [[ -d ${D}/opt/${PN}/resources/${lng}.${i} ]] ; then
						rm -rvf ${D}/opt/${PN}/resources/${lng}.${i}
					fi
				fi
			done
		fi
	done
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	einfo ""
	einfo "Possibly there is not show Panoramio pictures in this soft."
	einfo "If you want your language interface, use qt4 useflag."
}

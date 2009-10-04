# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/googleearth/googleearth-5.1.3509.4636_beta.ebuild,v 1.1 2009/10/03 12:12:54 caster Exp $

EAPI=2

inherit eutils fdo-mime

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
IUSE="+curl +gcc -icu +mesa +qt4"

DEPEND="gcc? ( sys-devel/gcc-config )"

RDEPEND="
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
	curl? ( >=net-misc/curl-7.19.4 )
	qt4? ( >=x11-libs/qt-core-4.4.2
			>=x11-libs/qt-gui-4.4.2
			>=x11-libs/qt-webkit-4.4.2 )
	mesa? ( >=media-libs/mesa-6.5.2 )
	icu? ( =dev-libs/icu-3.8* )"

S="${WORKDIR}"

LANGS="ad ae af ag ai al am an ao aq ar as at au aw ax az ba bb bd be bf bg bh bi bj bm bn bo br bs bt bv bw by bz ca cc cd cf cg ch ci ck cl cm cn co cr cs cu cv cx cy cz da de dj dk dm do dz ec ee eg eh el er es et fi fil fj fk fm fo fr ga gb gd ge gf gg gh gi gl gm gn gp gq gr gs gt gu gw gy he hi hk hm hn hr ht hu id ie il im in io iq ir is it ja je jm jo jp ke kg kh ki km kn ko kp kr kw ky kz la lb lc li lk lr ls lt lu lv ly ma mc md me mg mh mk ml mm mn mo mp mq mr ms mt mu mv mw mx my mz na nc ne nf ng ni nl no np nr nu nz om pa pe pf pg ph pk pl pm pn pr ps pt-PT pt pw py qa re ro rs ru rw sa sb sc sd se sg sh si sj sk sl sm sn so sr st sv sy sz tc td tf tg th tj tk tl tm tn to tr tt tv tw tz ua ug uk um uy uz va vc ve vg vi vn vu wf ws ye yt za zh-Hans zh-Hant zm zw"
for lng in ${LANGS} ; do
	IUSE="${IUSE} linguas_${lng}"
done

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
opt/googleearth/libmoduleframework.so"

QA_DT_HASH="opt/${PN}/.*"

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

	if use curl ; then
		ln -svf /usr/lib/libcurl.so.4 libcurl.so.4
	fi
	if use qt4 ; then
		ln -svf /usr/lib/qt4/libQtCore.so.4 libQtCore.so.4
		ln -svf /usr/lib/qt4/libQtNetwork.so.4 libQtNetwork.so.4
		ln -svf /usr/lib/qt4/libQtGui.so.4 libQtGui.so.4
		ln -svf /usr/lib/qt4/plugins/imageformats/libqgif.so plugins/imageformats/libqgif.so
		ln -svf /usr/lib/qt4/plugins/imageformats/libqjpeg.so plugins/imageformats/libqjpeg.so
	fi
	if use mesa ; then
		ln -svf /usr/lib/libGLU.so.1 libGLU.so.1
	fi
	if use icu ; then
		ln -svf /usr/lib/libicudata.so.38 libicudata.so.38
		ln -svf /usr/lib/libicuuc.so.38 libicuuc.so.38
	fi

	fowners -R root:root /opt/${PN}
	fperms -R a-x,a+X /opt/googleearth/{xml,resources}
}

pkg_preinst() {
	for lng in ${LANGS} ; do
		if ! use linguas_${lng} ; then
			if [[ ${lng} = "es" ]] ; then
				rm -vf ${D}/opt/${PN}/lang/${lng}*.qm
			else
				if [[ -f ${D}/opt/${PN}/lang/${lng}.qm ]] ; then
					rm -vf ${D}/opt/${PN}/lang/${lng}.qm
				fi
			fi
			if [[ -f ${D}/opt/${PN}/resources/${lng}.country ]] ; then
				rm -vf ${D}/opt/${PN}/resources/${lng}.country
			fi
			if [[ -d ${D}/opt/${PN}/resources/${lng}.country ]] ; then
				rm -rvf ${D}/opt/${PN}/resources/${lng}.country
			fi
			if [[ -f ${D}/opt/${PN}/resources/${lng}.locale ]] ; then
				rm -vf ${D}/opt/${PN}/resources/${lng}.locale
			fi
			if [[ -d ${D}/opt/${PN}/resources/${lng}.locale ]] ; then
				rm -rvf ${D}/opt/${PN}/resources/${lng}.locale
			fi
		fi
	done
}

pkg_postinst() {
	rm /opt/googleearth/qt.conf
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	einfo "Note, thah using USE flags curl, gcc, mesa, icu, zlib and qt4"
	einfo "will link binary against yout system libraries and may block"
	einfo "their versions. So be carefull using them. Good Luck :)"
	einfo "In that case better to set USE=\"-icu\" for that package"
}

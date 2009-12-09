# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/audacious-plugins/audacious-plugins-2.2-r2.ebuild,v 1.1 2009/11/25 01:49:32 robbat2 Exp $

inherit eutils flag-o-matic

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="http://audacious-media-player.org/"
SRC_URI="http://distfiles.atheme.org/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="aac adplug alsa bs2b cdda cue esd ffmpeg flac fluidsynth gnome icecast ipv6 jack lame lirc
midi mp3 mtp nls oss pulseaudio projectm scrobbler sdl sid sndfile sse2 vorbis wavpack
linguas_ru"

RDEPEND="app-arch/unzip
	>=dev-libs/dbus-glib-0.60
	dev-libs/libxml2
	>=media-sound/audacious-2.2
	>=net-misc/neon-0.26.4
	>=x11-libs/gtk+-2.14
	aac? ( >=media-libs/faad2-2.7-r1 )
	adplug? ( >=dev-cpp/libbinio-1.4 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	bs2b? ( media-libs/libbs2b )
	cdda? ( >=media-libs/libcddb-1.2.1
		>=dev-libs/libcdio-0.79-r1 )
	cue? ( media-libs/libcue )
	esd? ( >=media-sound/esound-0.2.38-r1 )
	flac? ( >=media-libs/libvorbis-1.0
		>=media-libs/flac-1.2.1-r1 )
	fluidsynth? ( media-sound/fluidsynth )
	icecast? ( media-libs/libshout )
	jack? ( >=media-libs/bio2jack-0.4
		media-sound/jack-audio-connection-kit )
	lame? ( media-sound/lame )
	lirc? ( app-misc/lirc )
	mp3? ( media-libs/libmad )
	mtp? ( media-libs/libmtp )
	projectm? ( >=media-libs/libprojectm-1.2.0
		>=media-libs/libsdl-1.2.5
		x11-libs/gtkglext )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.3 )
	scrobbler? ( net-misc/curl )
	sdl? (	>=media-libs/libsdl-1.2.5 )
	sid? ( >=media-libs/libsidplay-2.1.1-r2 )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
	vorbis? ( >=media-libs/libvorbis-1.2.0
		  >=media-libs/libogg-1.1.3 )
	wavpack? ( >=media-sound/wavpack-4.41.0 )"

DEPEND="${RDEPEND}
	nls? ( dev-util/intltool )
	>=dev-util/pkgconfig-0.9.0"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-jackcompat.patch"

	# russian letters patch
	if use linguas_ru ; then
		epatch "${FILESDIR}"/"${PV}"-russian-letters-in-main-window.patch
	fi
}

mp3_warning() {
	if ! useq mp3 ; then
		ewarn "MP3 support is optional, you may want to enable the mp3 USE-flag"
	fi
}

src_compile() {
	mp3_warning

	econf \
		--enable-chardet \
		--enable-dbus \
		--enable-modplug \
		--enable-neon \
		--disable-coreaudio \
		--disable-dockalbumart \
		--disable-projectm \
		$(use_enable adplug) \
		$(use_enable aac) \
		$(use_enable alsa) \
		$(use_enable alsa bluetooth) \
		$(use_enable alsa amidiplug-alsa) \
		$(use_enable bs2b) \
		$(use_enable cdda cdaudio) \
		$(use_enable cue) \
		$(use_enable esd) \
		$(use_enable ffmpeg ffaudio) \
		$(use_enable flac flacng) \
		$(use_enable fluidsynth amidiplug-flsyn) \
		$(use_enable flac filewriter_flac) \
		$(use_enable icecast) \
		$(use_enable ipv6) \
		$(use_enable jack) \
		$(use_enable gnome gnomeshortcuts) \
		$(use_enable lame filewriter_mp3) \
		$(use_enable lirc) \
		$(use_enable mp3) \
		$(use_enable midi amidiplug) \
		$(use_enable mtp mtp_up) \
		$(use_enable nls) \
		$(use_enable oss) \
		$(use_enable projectm projectm-1.0) \
		$(use_enable pulseaudio pulse) \
		$(use_enable sdl paranormal) \
		$(use_enable sid) \
		$(use_enable sndfile) \
		$(use_enable sse2) \
		$(use_enable vorbis) \
		$(use_enable vorbis filewriter_vorbis) \
		$(use_enable wavpack) \
		|| die

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS
}

pkg_preinst() {
	# Classic1.3, Classic, Osmosis, TinyPlayer (same `text.png`)
	# Default, Ivory, Refugee (have own `text.png`)
	# themes picture russian symbols fix
	if use linguas_ru ; then
		tar -xjf "${FILESDIR}"/"${PV}"-russian-skins-text-changes-other.tar.bz2 -C "${D}"/usr/share/audacious
		dosym ../Classic1.3/text.png /usr/share/audacious/Skins/Classic/text.png
		dosym ../Classic1.3/text.png /usr/share/audacious/Skins/Osmosis/text.png
		dosym ../Classic1.3/text.png /usr/share/audacious/Skins/TinyPlayer/text.png
	fi
}

pkg_postinst() {
	mp3_warning
}

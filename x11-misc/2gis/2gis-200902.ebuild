# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Proprietary free multimedia map of 21 Russian and Ukrainian towns"
HOMEPAGE="http://2gis.ru/"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~x86"

CITIES="ekb astr barn biysk irk kaz kem kras kur nvar nnov nkuz nsib odes omsk perm sam tom tum ufa chel"
IUSE="${CITIES}"

SRC_URI="http://download.2gis.ru/arhives/2GISShell-3.0.4.1.zip
	ekb? ( http://download.2gis.ru/arhives/2GISData_Ekaterinburg-38.zip )
	astr? ( http://download.2gis.ru/arhives/2GISData_Astrakhan-39.zip )
	barn? ( http://download.2gis.ru/arhives/2GISData_Barnaul-48.zip )
	biysk? ( http://download.2gis.ru/arhives/2GISData_Biysk-4.zip )
	irk? ( http://download.2gis.ru/arhives/2GISData_Irkutsk-34.zip )
	kaz? ( http://download.2gis.ru/arhives/2GISData_Kazan-3.zip )
	kem? ( http://download.2gis.ru/arhives/2GISData_Kemerovo-46.zip )
	kras? ( http://download.2gis.ru/arhives/2GISData_Krasnoyarsk-42.zip )
	kur? ( http://download.2gis.ru/arhives/2GISData_Kurgan-35.zip )
	nvar? ( http://download.2gis.ru/arhives/2GISData_Nizhnevartovsk-33.zip )
	nnov? ( http://download.2gis.ru/arhives/2GISData_N_Novgorod-5.zip )
	nkuz? ( http://download.2gis.ru/arhives/2GISData_Novokuznetsk-42.zip )
	nsib? ( http://download.2gis.ru/arhives/2GISData_Novosibirsk-125.zip )
	odes? ( http://2gis.com.ua/arhives/2GISData_Odessa-24.zip )
	omsk? ( http://download.2gis.ru/arhives/2GISData_Omsk-54.zip )
	perm? ( http://download.2gis.ru/arhives/2GISData_Perm-14.zip )
	sam? ( http://download.2gis.ru/arhives/2GISData_Samara-7.zip )
	tom? ( http://2gis.tomsk.ru/arhives/2GISData_Tomsk-50.zip )
	tum? ( http://download.2gis.ru/arhives/2GISData_Tyumen-27.zip )
	ufa? ( http://download.2gis.ru/arhives/2GISData_Ufa-11.zip )
	chel? ( http://download.2gis.ru/arhives/2GISData_Chelyabinsk-18.zip )"

DEPEND=">=app-emulation/wine-1.0_rc1"

RDEPEND="${DEPEND}
	app-arch/p7zip
	media-gfx/icoutils"

src_unpack() {
	einfo "Unpacking 2gis core files"
	mkdir "${WORKDIR}"/data
	mkdir "${WORKDIR}"/core
	7z x -ocore -y "${DISTDIR}"/2GISShell-3.0.4.1.zip
	cd "${WORKDIR}"/core
	7z x -y 2GISShell-3.0.4.1.msi
	mkdir cab
	7z x -ocab -y Sample.cab
	cd "${DISTDIR}"/
	local map
	for map in $(ls|grep -P 2GISData_.*zip); do
		city=`echo $map | cut -d '_' -f 2 | cut -d '-' -f 1`
		einfo "Unpacking 2gis data files for $city"
		cd "${WORKDIR}"/
		7z x -odata -y "${DISTDIR}/$map"
		cd data
		mmap=`echo $map | sed -e 's/zip/msi/'`
		7z x -y $mmap
		mkdir cab
		7z x -ocab -y Sample.cab
	done
	#else die "You should enable at least one of USE-flags to use this program"
	mkdir "${WORKDIR}"/icon || die "mkdir"
	cd "${WORKDIR}"/icon
	cp "${WORKDIR}"/core/Icon.grym.exe "${WORKDIR}"/icon/ || die "cp"
	icotool -x Icon.grym.exe
}

src_install() {
	instdir=/opt/2gis
	cd "${WORKDIR}"/core/cab
	insinto /opt/2gis/lib/Plugins/
	local i
	for i in $(ls|grep -P DG.*Chm); do
		i2=`echo $i | sed -e 's/Chm/\.chm/'`
		newins $i $i2 || die "newins failed"
	done
	for i in $(ls|grep -P DG.*Sgn); do
		i2=`echo $i | sed -e 's/Sgn/\.sgn/'`
		newins $i $i2 || die "newins failed"
	done
	for i in $(ls|grep -P DG.*Dll); do
		i2=`echo $i | sed -e 's/Dll/\.dll/'`
		newins $i $i2 || die "newins failed"
	done
	insinto /opt/2gis/lib/
	newins grymEXE grym.exe || die "newins failed"
	newins grymChm grym.chm || die "newins failed"
	newins imgChm img.chm || die "newins failed"
	cd "${WORKDIR}"/data/cab
	einfo ""
	local map
	for map in $(ls|grep -P .*_DGDAT); do
		city=`echo $map | cut -d '_' -f 1`
		einfo "Installing data files for for $city"
		newins $map "$city.dgdat" || die "newins failed"
	done
	einfo ""
	newicon "${WORKDIR}"/icon/Icon.grym.exe_3_64x64x32.png 2gis.png || "newicon failed"
	make_desktop_entry "/usr/bin/wine /opt/2gis/lib/grym.exe" "ДубльГИС" "2gis.png" "Application;Utility;Wine;Geography" || die "make_desktop_entry failed"
}

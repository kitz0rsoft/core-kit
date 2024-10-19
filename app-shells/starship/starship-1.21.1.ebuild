# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="The minimal, blazing-fast, and infinitely customizable prompt for any shell"
HOMEPAGE="https://github.com/starship/starship"
SRC_URI="https://github.com/starship/starship/tarball/47ccc3603dc20edf4bb59e56b26d19f78a41e770 -> starship-1.21.1-47ccc36.tar.gz
https://regen.mordor/54/06/86/540686e1265aa5bf7c7d0eeae4ac4557547795091bf08fc73d9c5e43cb083b5f58fbf2b7f83deb773dd3db3fefa299b473d30fb4f77866bec9e7c23b8b8d842f -> starship-1.21.1-funtoo-crates-bundle-7881ce92f88c42c2a51b28d91f640bf61039c861bed8cdca45ab2877c2d94f9d2ab01b470c678eddf34e1085a41e1eaffc245716483f73ca5be7c3c7b6d60580.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="*"
IUSE="libressl"

DEPEND="
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/rust"

DOCS="docs/README.md"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/starship-starship-* ${S} || die
}

src_install() {
	dobin target/release/${PN}
	default
}

pkg_postinst() {
	echo
	elog "Thanks for installing starship."
	elog "For better experience, it's suggested to install some Powerline font."
	elog "You can get some from https://github.com/powerline/fonts"
	echo
}
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo llvm

DESCRIPTION="A suite of tools for thin provisioning on Linux"
HOMEPAGE="https://github.com/jthornber/thin-provisioning-tools"
SRC_URI="https://github.com/jthornber/thin-provisioning-tools/tarball/97c3b01816f764714e4a8147feaabd6db4ecb6ed -> thin-provisioning-tools-1.2.0-97c3b01.tar.gz
https://regen.mordor/a8/07/99/a8079912d632ec9fedc4b53e3f244c2da75e9ee46d22747e80cfac1a7ad21fde4816f295fc79127e22f7745677bce236f8ada2cce90f8fb6119d2ed8a3e52cb7 -> thin-provisioning-tools-1.2.0-funtoo-crates-bundle-377b5111b68fbe8de90cc28ac4ef7c1d9011a59b5588f0f36135422e4dc6b503868ba72550fc6bbf9a9da503ddd596d798d301cb05f163967661e22babfec413.tar.gz"


LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

IUSE="io-uring"

# for io-uring rio create needed to be different than declared in cargo.toml (exactly, from gentoo ebuild: '[rio]=https://github.com/jthornber/rio;2979a720f671e836302c01546f9cc9f7988610c8;rio-%commit%')
# doing block by version and hope, that will be fixed in next release
DEPEND="
	io-uring? ( !!<=sys-block/thin-provisioning-tools-1.0.14 )
	sys-fs/lvm2
"

# bindgen needs libclang.so 

BDEPEND="${RDEPEND}
	virtual/pkgconfig
	>=virtual/rust-1.75
	app-text/asciidoc
	sys-devel/clang
	sys-fs/lvm2
"


PATCHES=(
	"${FILESDIR}/${PN}-1.0.6-build-with-cargo.patch"
)

DOCS=(
	CHANGES
	COPYING
	README.md
	doc/TODO.md
	doc/thinp-version-2/notes.md
)

# Rust
QA_FLAGS_IGNORED="usr/sbin/pdata_tools"


src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/jthornber-thin-provisioning-tools-* ${S} || die

	# Patch rio library to ignore unused qualifications.
	# Needed for io-uring use flag.
	sed -i -e '/unused_qualifications/d' \
		${WORKDIR}/funtoo-crates-bundle-${PN}/*rio-*/src/lib.rs
}

src_configure() {
	# it look like sys-devel/clang problem or llvm.eclass need update
	export BINDGEN_EXTRA_CLANG_ARGS="${BINDGEN_EXTRA_CLANG_ARGS} -I/usr/lib/clang/$(get_llvm_slot)/include"

	local myfeatures=( $(usex io-uring io_uring '') )
	cargo_src_configure
}

src_install() {
	# took from gentoo cargo.eclass:cargo_target_dir function
	cargo_target_dir="${CARGO_TARGET_DIR:-target}/$(usex debug debug release)"

	emake \
		DESTDIR="${D}" \
		DATADIR="${ED}/usr/share" \
		PDATA_TOOLS="${cargo_target_dir}/pdata_tools" \
		install

	einstalldocs
}

# vim: filetype=ebuild ts=4 noet
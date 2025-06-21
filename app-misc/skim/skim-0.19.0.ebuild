# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/94b19ab847e2093768d5828be1b0ccf35ea71924 -> skim-0.19.0-94b19ab.tar.gz
https://regen.mordor/6d/21/03/6d2103afd612d8c779d7c6354854ae73915930a5351cc770846ce9321b806dd9dcfba6d903f8cd84def4390cd1f48e6f299d40483f96b0354763c48931f57a09 -> skim-0.19.0-funtoo-crates-bundle-f4c5ddaf875b4c07ee593e59c5d7850137dc4f9138cb8466ef82ad17adcd1b90ab22c43d4cf938c6f13c5fac82b3a81a379ef7134f706d84b81e899be8ef0ee2.tar.gz"

LICENSE="Apache-2.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="*"
IUSE="tmux vim"

RDEPEND="
	tmux? ( app-misc/tmux )
	vim? ( || ( app-editors/vim app-editors/gvim ) )
"
BDEPEND="virtual/rust"

QA_FLAGS_IGNORED="usr/bin/sk"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/skim-rs-skim-* ${S} || die
}

src_install() {
	# prevent cargo_src_install() blowing up on man installation
	mv man manpages || die

	cargo_src_install --path skim
	dodoc CHANGELOG.md README.md
	doman manpages/man1/*

	use tmux && dobin bin/sk-tmux

	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins plugin/skim.vim
	fi

	# install bash/zsh completion and keybindings
	# since provided completions override a lot of commands, install to /usr/share
	insinto /usr/share/${PN}
	doins shell/{*.bash,*.zsh}
}
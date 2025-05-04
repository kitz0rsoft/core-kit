# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/efa998df2522e7d4ea1fc3fd8deb396febaa88e4 -> skim-0.17.0-efa998d.tar.gz
https://regen.mordor/31/85/6f/31856f4bb440d21dc34348d8eeca9d2fc66b0d3bfb4da3d1038b756c6cc81b7aee389dabfb668dd022d11af8a175c26eca3927a95a84f58bf04f3a97f315195c -> skim-0.17.0-funtoo-crates-bundle-de8a8cd8a1bcc39f78b1f95a29c48fd473ad37d5199d14fabdbdb4419746f5733131f4c1d41e3bdfe2aea6be470229bfebed8a81a0669534b1291ffb84efb487.tar.gz"

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
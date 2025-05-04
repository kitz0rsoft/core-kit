# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/35bf6964c454c406a75ddf96d2235574a4553c2d -> skim-0.17.1-35bf696.tar.gz
https://regen.mordor/f9/a9/dd/f9a9dd68f52248821c5d2e1ff07590b63a291266c667a57163a996659acb22bc5fd49b35489e09602bd1fe435f4052c4f5d6ea7ee77ad52bca23932169b8c603 -> skim-0.17.1-funtoo-crates-bundle-de8a8cd8a1bcc39f78b1f95a29c48fd473ad37d5199d14fabdbdb4419746f5733131f4c1d41e3bdfe2aea6be470229bfebed8a81a0669534b1291ffb84efb487.tar.gz"

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
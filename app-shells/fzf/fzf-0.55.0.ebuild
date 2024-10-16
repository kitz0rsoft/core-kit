# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module

DESCRIPTION="A general-purpose command-line fuzzy finder, written in GoLang"
HOMEPAGE="https://github.com/junegunn/fzf"

EGO_SUM=(
	"github.com/charlievieth/fastwalk v1.0.8"
	"github.com/charlievieth/fastwalk v1.0.8/go.mod"
	"github.com/gdamore/encoding v1.0.0"
	"github.com/gdamore/encoding v1.0.0/go.mod"
	"github.com/gdamore/tcell/v2 v2.7.4"
	"github.com/gdamore/tcell/v2 v2.7.4/go.mod"
	"github.com/junegunn/go-shellwords v0.0.0-20240813092932-a62c48c52e97"
	"github.com/junegunn/go-shellwords v0.0.0-20240813092932-a62c48c52e97/go.mod"
	"github.com/lucasb-eyer/go-colorful v1.2.0"
	"github.com/lucasb-eyer/go-colorful v1.2.0/go.mod"
	"github.com/mattn/go-isatty v0.0.20"
	"github.com/mattn/go-isatty v0.0.20/go.mod"
	"github.com/mattn/go-runewidth v0.0.15"
	"github.com/mattn/go-runewidth v0.0.15/go.mod"
	"github.com/rivo/uniseg v0.2.0/go.mod"
	"github.com/rivo/uniseg v0.4.3/go.mod"
	"github.com/rivo/uniseg v0.4.7"
	"github.com/rivo/uniseg v0.4.7/go.mod"
	"github.com/yuin/goldmark v1.4.13/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20210921155107-089bfa567519/go.mod"
	"golang.org/x/mod v0.6.0-dev.0.20220419223038-86c51ed26bb4/go.mod"
	"golang.org/x/mod v0.8.0/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
	"golang.org/x/net v0.0.0-20220722155237-a158d28d115b/go.mod"
	"golang.org/x/net v0.6.0/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sync v0.0.0-20220722155255-886fb9371eb4/go.mod"
	"golang.org/x/sync v0.1.0/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
	"golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a/go.mod"
	"golang.org/x/sys v0.0.0-20220722155257-8c9f86f7a55f/go.mod"
	"golang.org/x/sys v0.5.0/go.mod"
	"golang.org/x/sys v0.6.0/go.mod"
	"golang.org/x/sys v0.17.0/go.mod"
	"golang.org/x/sys v0.24.0"
	"golang.org/x/sys v0.24.0/go.mod"
	"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
	"golang.org/x/term v0.0.0-20210927222741-03fcf44c2211/go.mod"
	"golang.org/x/term v0.5.0/go.mod"
	"golang.org/x/term v0.17.0/go.mod"
	"golang.org/x/term v0.23.0"
	"golang.org/x/term v0.23.0/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/text v0.3.7/go.mod"
	"golang.org/x/text v0.7.0/go.mod"
	"golang.org/x/text v0.14.0"
	"golang.org/x/text v0.14.0/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
	"golang.org/x/tools v0.1.12/go.mod"
	"golang.org/x/tools v0.6.0/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
)

go-module_set_globals

SRC_URI="https://github.com/junegunn/fzf/tarball/6d71138ffb3c05ebdf2d5e55987d2e7e3a40b34e -> fzf-0.55.0-6d71138.tar.gz
https://regen.mordor/51/b2/09/51b209cf4c80bfd4984faeee76175a5c8fa4698910619eaf363a3fbb559a80d0a51a680e04486a0f25cb68b0151374523e73a10c043b601f34292c04a11753a7 -> fzf-0.55.0-funtoo-go-bundle-bc1a92167faf973c2bfb8788e352761a6aa93f1ae89653663c2945a854792a509187e7da4a17ba45eb9b93243f1bb058df68edcb039eec581eab55d477da903d.tar.gz"

LICENSE="MIT BSD-with-disclosure"
SLOT="0"
KEYWORDS="*"

post_src_unpack() {
	mv ${WORKDIR}/junegunn* ${S} || die
}

src_compile() {
	emake PREFIX=${EPREFIX}/usr FZF_VERSION=${PV} FZF_REVISION=tarball bin/${PN}
}

src_install() {
	dobin bin/${PN}
	doman man/man1/${PN}.1

	dobin bin/${PN}-tmux
	doman man/man1/${PN}-tmux.1

	insinto /usr/share/vim/vimfiles/plugin
	doins plugin/${PN}.vim

	insinto /usr/share/nvim/runtime/plugin
	doins plugin/${PN}.vim

	newbashcomp shell/completion.bash ${PN} || die

	insinto /usr/share/zsh/site-functions
	newins shell/completion.zsh _${PN}

	insinto /usr/share/fzf
	doins shell/key-bindings.bash
	doins shell/key-bindings.fish
	doins shell/key-bindings.zsh
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "To add fzf support to your shell, make sure to use the right file"
		elog "from /usr/share/fzf."
		elog
		elog "For bash, add the following line to ~/.bashrc:"
		elog
		elog "	# source /usr/share/fzf/key-bindings.bash"
		elog
		elog "Or create a symlink:"
		elog
		elog "	# ln -s /usr/share/fzf/key-bindings.bash /etc/bash/bashrc.d/fzf.bash"
		elog
		elog "Plugins for Vim and Neovim are installed to respective directories"
		elog "and will work out of the box."
		elog
		elog "For fzf support in tmux see fzf-tmux(1)."
	fi
}
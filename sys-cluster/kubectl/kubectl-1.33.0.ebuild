# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to run commands against Kubernetes clusters"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/tarball/a42c4d251150d33c4b15cb8aef3759d7599551e6 -> kubernetes-1.33.0-a42c4d2.tar.gz
https://regen.mordor/5d/9c/97/5d9c970ac9f3200e71d34066ee188a921d56056291fc10f6a3a13453dce20efc3f9d1a6e57266e9f1f363d58223ce22313d58c96d331ed6136b17223f923be3a -> kubectl-1.33.0-funtoo-go-bundle-6d80ab83d4b29f8cd2cb34b1559aee2366d2045f27c2488d031911868c8c5ab13f9589ccbd879ed64577dd305bbe9eb90b43aedb5dc476afa1bb6ec4e431de7c.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="hardened"

DEPEND="!sys-cluster/kubernetes"
BDEPEND=">=dev-lang/go-1.21"

RESTRICT+=" test"

src_unpack() {
	default
	rm -rf ${S}
	mv ${WORKDIR}/kubernetes-kubernetes-* ${S} || die
}

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
	FORCE_HOST_GO=yes \
		emake -j1 GOFLAGS="" GOLDFLAGS="" LDFLAGS="" WHAT=cmd/${PN}
}

src_install() {
	dobin _output/bin/${PN}
	_output/bin/${PN} completion bash > ${PN}.bash || die
	_output/bin/${PN} completion zsh > ${PN}.zsh || die
	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}
}
{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, libyamlcpp, systemd
, python3Packages, asciidoc, libxslt, docbook_xml_dtd_45, docbook_xsl
, libxml2, docbook5
}:

stdenv.mkDerivation rec {
  pname = "ip2unix";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "nixcloud";
    repo = "ip2unix";
    rev = "v${version}";
    sha256 = "121ygj50i7ja9bv76y51qsjbjmmydhpi0sd3xb6pysmlzv0bxn17";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig asciidoc libxslt.bin docbook_xml_dtd_45 docbook_xsl
    libxml2.bin docbook5 python3Packages.pytest python3Packages.pytest-timeout
    systemd
  ];

  buildInputs = [ libyamlcpp ];

  doCheck = true;

  doInstallCheck = true;
  installCheckPhase = ''
    found=0
    for man in "$out/share/man/man1"/ip2unix.1*; do
      test -s "$man" && found=1
    done
    if [ $found -ne 1 ]; then
      echo "ERROR: Manual page hasn't been generated." >&2
      exit 1
    fi
  '';

  meta = {
    homepage = "https://github.com/nixcloud/ip2unix";
    description = "Turn IP sockets into Unix domain sockets";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ stdenv.lib.maintainers.aszlig ];
  };
}

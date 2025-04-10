# Path to oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git z zsh-autosuggestions ssh-agent)
zstyle :omz:plugins:ssh-agent identities npietanze@eightpoint.io
source $ZSH/oh-my-zsh.sh

# Aliases
alias ~="~"
alias dev="~/dev"
alias config="~/.config"
alias desktop="~/desktop"
alias downloads="~/downloads"
alias nix-config="/etc/nixos/"
alias nix-rebuild="sudo nixos-rebuild switch"

# dotnet setup
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$DOTNET_ROOT:$HOME/bin:$PATH"

# Shared libraries (GCC 14, ICU, OpenSSL)
export LD_LIBRARY_PATH="/nix/store/7pnv4baq3q9vbkp54b5pz10kv7s8w7h4-gcc-14.2.0-lib/lib:\
/nix/store/qgij2wczc4vx1rhwf911mv491dx1n65i-icu4c-76.1/lib:\
/nix/store/mqvgaq2bnb1701l7zcn0d6vd7w8b0z7l-openssl-3.3.3/lib:\
/nix/store/vpg96mfr1jw5arlqg831i69g29v0sdb3-zlib-1.3.1/lib"

# Certificate authority
export SSL_CERT_FILE="/nix/store/9zxb5ln0awpc13s0gv1vz7f28wyvn2x1-nss-cacert-3.108/etc/ssl/certs/ca-bundle.crt"
export CURL_CA_BUNDLE="$SSL_CERT_FILE"

# Enable full globalization
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# Prevent HTTP handler issues (NuGet)
export DOTNET_SYSTEM_NET_HTTP_USESOCKETSHTTPHANDLER=0

# dotnet wrapper with preloaded runtime libs
dotnet_with_env() {
  export LD_PRELOAD="/nix/store/qgij2wczc4vx1rhwf911mv491dx1n65i-icu4c-76.1/lib/libicuuc.so:\
/nix/store/qgij2wczc4vx1rhwf911mv491dx1n65i-icu4c-76.1/lib/libicui18n.so:\
/nix/store/mqvgaq2bnb1701l7zcn0d6vd7w8b0z7l-openssl-3.3.3/lib/libssl.so.3:\
/nix/store/mqvgaq2bnb1701l7zcn0d6vd7w8b0z7l-openssl-3.3.3/lib/libcrypto.so.3:\
/nix/store/vpg96mfr1jw5arlqg831i69g29v0sdb3-zlib-1.3.1/lib/libz.so.1"
  "$DOTNET_ROOT/dotnet" "$@"
}
alias dotnet=dotnet_with_env


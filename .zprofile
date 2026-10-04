# Versioned Homebrew toolchains (Rustup and Zig matching ZLS 0.16).
typeset -U path PATH
for nvim_toolchain_bin in /opt/homebrew/opt/rustup/bin /opt/homebrew/opt/zig@0.16/bin; do
  [[ -d "$nvim_toolchain_bin" ]] && path=("$nvim_toolchain_bin" $path)
done
unset nvim_toolchain_bin
export PATH

# Login shells initialize command paths; .zshrc covers non-login terminals too.
typeset -U path PATH
path=("$HOME/.local/bin" $path)
if [[ -d /Applications/ChatGPT.app/Contents/Resources/codex-cli/CodexCLI.app/Contents/MacOS ]]; then
  path=(/Applications/ChatGPT.app/Contents/Resources/codex-cli/CodexCLI.app/Contents/MacOS $path)
fi
# Homebrew on Apple Silicon.
if [[ -d /opt/homebrew/bin ]]; then
  path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
fi
# User-installed .NET SDK and its command-line tools.
if [[ -x "$HOME/.dotnet/dotnet" ]]; then
  export DOTNET_ROOT="$HOME/.dotnet"
  path=("$DOTNET_ROOT" "$DOTNET_ROOT/tools" $path)
fi
export PATH

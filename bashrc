if command -v xdg-open > /dev/null 2>&1; then
  alias open='xdg-open'
fi

if command -v xsel > /dev/null 2>&1; then
  alias pbcopy='xsel --clipboard --input'
fi

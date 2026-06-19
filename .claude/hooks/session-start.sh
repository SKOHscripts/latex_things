#!/bin/bash
# SessionStart hook: install LaTeX + PDF/image + security tooling for Claude Code
# on the web sessions, so the CV can be compiled and documents can be checked.
set -euo pipefail

# Only run in the remote (web) environment; do nothing locally.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Idempotent: if the key tools are already present, skip the (slow) install.
need_install=false
for bin in pdflatex pdfinfo exiftool pngcheck clamscan convert; do
  command -v "$bin" >/dev/null 2>&1 || need_install=true
done

if [ "$need_install" = true ]; then
  export DEBIAN_FRONTEND=noninteractive

  SUDO=""
  [ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1 && SUDO="sudo"

  # Tolerate failures from any pre-configured third-party PPAs that the
  # environment's network policy may block; the main archive is what we need.
  $SUDO apt-get update -qq || true

  # LaTeX (pdflatex/xelatex/lualatex) — subset covering the CV's packages
  # (AlegreyaSans, beuron, fontawesome, paracol, tcolorbox, tikz, smartdiagram,
  #  titlesec, french babel, siunitx, ...) plus bibtex/biber.
  # PDF/image tooling: poppler-utils, imagemagick, ghostscript, qpdf.
  # Security / "cyber" tooling: clamav, pngcheck, exiftool.
  $SUDO apt-get install -y --no-install-recommends \
    texlive-latex-base texlive-latex-recommended texlive-latex-extra \
    texlive-fonts-recommended texlive-fonts-extra \
    texlive-lang-french texlive-pictures texlive-science \
    texlive-xetex texlive-luatex texlive-bibtex-extra biber latexmk \
    poppler-utils imagemagick ghostscript qpdf \
    clamav pngcheck libimage-exiftool-perl

  # ClamAV needs a signature database for clamscan to work. Best-effort:
  # a failed/slow mirror must not break session startup.
  $SUDO systemctl stop clamav-freshclam 2>/dev/null || true
  $SUDO freshclam --quiet 2>/dev/null || \
    echo "WARN: freshclam DB update skipped/failed; clamscan needs a DB to scan." >&2
fi

# Python dependencies for the latex-document-skill scripts (charts, mail-merge,
# PDF forms, etc.), if the skill is present in the repo. Best-effort.
REQ="$CLAUDE_PROJECT_DIR/.claude/skills/latex-document-skill/requirements.txt"
if [ -f "$REQ" ] && command -v pip3 >/dev/null 2>&1; then
  pip3 install --quiet --break-system-packages -r "$REQ" 2>/dev/null || \
    pip3 install --quiet -r "$REQ" 2>/dev/null || \
    echo "WARN: could not install Python deps from $REQ" >&2
fi

echo "session-start hook: LaTeX + PDF/image + security tooling ready."

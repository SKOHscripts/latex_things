# CLAUDE.md

Guide pour travailler dans ce dépôt avec Claude Code.

## Vue d'ensemble

Dépôt de documents LaTeX (CV, récits) + outillage complet de génération/vérification
de PDF. Tous les outils LaTeX/PDF/sécurité sont installés au démarrage des sessions
web par `.claude/hooks/session-start.sh`.

## Structure

- `CV_Corentin_Michel/` — CV (classe `modernsimplecv`, compile en **pdfLaTeX**).
  `modernsimplecv.cls` + `modernsimplecv.sty` définissent les macros (`\cvevent`,
  `\cveventraw`, `\cvtag`, `\roundpic`, `\continuationline`…). Images dans
  `pictures/`. **Contient des données personnelles réelles** → ne pas inventer ni
  altérer les informations sans demande explicite.
- `récits/` — documents LaTeX autonomes (classe `article`).
- `.claude/skills/latex-document-skill/` — skill universel (templates, scripts, guides).
- `.claude/hooks/` + `.claude/settings.json` — hook d'installation de l'outillage.

## Construire un PDF

```bash
cd CV_Corentin_Michel
latexmk -pdf "CV - Corentin Michel.tex"        # ou pdflatex -interaction=nonstopmode ...
```

Le récit et la plupart des templates sont aussi en pdfLaTeX ; certains templates
multilingues/CJK passent en XeLaTeX (auto-détecté par `compile_latex.sh`).

## Linter / formater / vérifier

```bash
# Lint (utiliser la config du skill)
chktex -l .claude/skills/latex-document-skill/.chktexrc "fichier.tex"
lacheck "fichier.tex"

# Formatage automatique (in-place, crée une sauvegarde .bak)
latexindent -w "fichier.tex"

# Vérifier le PDF produit
qpdf --check "fichier.pdf"
pdfinfo "fichier.pdf"

# Aperçu PNG d'un PDF
pdftoppm -png -r 150 "fichier.pdf" apercu
```

## Vérification d'assets (sécurité)

```bash
pngcheck image.png            # intégrité PNG
exiftool fichier.pdf|png      # métadonnées
clamscan fichier              # antivirus (nécessite une base freshclam)
```

## Quel skill / outil pour quel besoin

Deux skills sont disponibles, complémentaires :

- **`tailored-resume-generator`** — *contenu & stratégie* : analyse une offre d'emploi,
  réorganise/met en avant l'expérience pertinente, optimise les mots-clés ATS
  (naturellement, dans le texte), et liste les manques à combler. À invoquer pour
  **optimiser/adapter le CONTENU d'un CV** à un poste, avant la mise en forme.
- **`latex-document-skill`** — *mise en forme & production* : rend le contenu en PDF
  LaTeX (templates, compilation, lint, conversion). À invoquer pour **créer/compiler/
  convertir** le document.

Workflow CV recommandé : `tailored-resume-generator` (quoi dire) → `latex-document-skill`
(comment le rendre) → métadonnées + vérifs (voir `CV_Corentin_Michel/REFERENCEMENT.md`).

| Besoin | Action |
|---|---|
| **Adapter/optimiser le contenu d'un CV à une offre** (priorisation, mots-clés ATS, manques) | skill **`tailored-resume-generator`** |
| Créer un CV / lettre / rapport / facture / article / thèse / présentation / poster / examen / fiche mémo | Partir d'un template de `.claude/skills/latex-document-skill/assets/templates/` |
| Compiler un `.tex` (auto-détection moteur, latexmk, filtrage du log) | `scripts/compile_latex.sh` |
| Valider la syntaxe / vérifier les `\usepackage` manquants | `scripts/validate_latex.py`, `scripts/latex_package_check.sh` |
| Linter | `chktex` (+ `.chktexrc`), `lacheck`, `scripts/latex_lint.sh` |
| Formater / corriger la mise en forme | `latexindent -w` |
| Comparer deux versions | `latexdiff` / `scripts/latex_diff.sh` |
| Compter les mots | `texcount` / `scripts/latex_wordcount.sh` |
| Graphiques (pgfplots / matplotlib) | `scripts/generate_chart.py` |
| Tables depuis CSV | `scripts/csv_to_latex.py` |
| Publipostage (mail merge CSV/JSON) | `scripts/mail_merge.py` |
| Diagrammes (Mermaid / Graphviz / PlantUML) | `scripts/mermaid_to_image.sh`, `graphviz_to_pdf.sh`, `plantuml_to_pdf.sh` |
| Opérations PDF (fusion, extraction de pages, optimisation, chiffrement, formulaires) | `scripts/pdf_*.sh` / `pdf_*.py` |
| Conversion Markdown/DOCX/HTML ↔ LaTeX, ou PDF → LaTeX (OCR) | `scripts/convert_document.sh` |

Guides détaillés dans `.claude/skills/latex-document-skill/references/`.

## Conventions

- **Ne jamais committer d'artefacts de build** (`*.aux`, `*.log`, `*.pdf` générés…) —
  ils sont déjà couverts par `.gitignore`. Le seul PDF versionné volontairement est
  `CV_Corentin_Michel/Reference letter.pdf` (source, pas un artefact).
- Après modification d'un `.tex`, **compiler pour vérifier** (build + `qpdf --check`).
- Garder le CV sur **une page A4** (hors lettre de référence) ; la mise en page est
  serrée, attention aux dépassements.
- Métadonnées PDF du CV : définies via `\hypersetup{...}` dans le préambule.

## Environnement web

Dans une session Claude Code web, le hook `SessionStart` installe TeX Live + les
outils de lint/format/vérif/sécurité. Il est **web-only**, **idempotent** et tolère
les PPA bloquées. En local, lancer `bash .claude/skills/latex-document-skill/setup.sh`.

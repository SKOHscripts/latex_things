# latex_things

Dépôt personnel regroupant des **documents LaTeX** (CV, récits) et un **outillage
complet pour générer, vérifier et convertir des PDF LaTeX** — pensé pour être
utilisé avec [Claude Code](https://claude.com/claude-code), mais utilisable à la
main avec n'importe quelle distribution TeX Live.

## Contenu

| Chemin | Description |
|---|---|
| `CV_Corentin_Michel/` | CV LaTeX (classe `modernsimplecv`) + images + lettre de référence |
| `récits/` | Textes / récits en LaTeX (ex. *Résistance à l'entropie*) |
| `.claude/skills/latex-document-skill/` | Skill universel LaTeX : 30 templates, scripts, guides de référence |
| `.claude/skills/tailored-resume-generator/` | Skill d'optimisation de CV : adapte le contenu à une offre, mots-clés ATS, recommandations |
| `.claude/hooks/session-start.sh` | Hook installant automatiquement l'outillage dans les sessions Claude Code web |
| `.claude/settings.json` | Enregistre le hook `SessionStart` |
| `.gitignore` | Ignore les artefacts de compilation LaTeX |

## ⚠️ À propos du CV

`CV_Corentin_Michel/` est le **CV personnel de Corentin Michel** : il contient des
**données personnelles réelles** (coordonnées, parcours, métadonnées PDF). Il est
public ici pour servir d'**exemple / de modèle** — la classe `modernsimplecv`, la
mise en page deux colonnes, les macros (`\cvevent`, `\cvtag`, `\roundpic`…) et les
métadonnées PDF sont réutilisables tels quels. **Remplace les informations
personnelles avant toute réutilisation.**

Voir aussi [**Bien référencer son CV PDF**](CV_Corentin_Michel/REFERENCEMENT.md) :
bonnes pratiques de nommage de fichier, de métadonnées (Info + XMP/Dublin Core),
de taille, d'accessibilité (PDF tagué) et de cohérence en ligne.

➡️ Tu veux convertir **ton propre CV** en LaTeX en gardant ton style ? Suis
[**CONVERTIR-MON-CV.md**](CONVERTIR-MON-CV.md) : un prompt prêt à coller dans Claude
Code qui reproduit ton CV en LaTeX, le compile en PDF et te dit quoi ajuster.

## Compiler un document

L'outillage est installé automatiquement dans les sessions Claude Code web (voir le
hook). En local, il faut une distribution TeX Live (voir
[Installer l'outillage](#installer-loutillage-manuellement)).

```bash
cd CV_Corentin_Michel
latexmk -pdf "CV - Corentin Michel.tex"      # build complet (recommandé)
# ou
pdflatex -interaction=nonstopmode "CV - Corentin Michel.tex"
```

Le CV se compile en **pdfLaTeX** → PDF 2 pages A4.

## Outillage disponible

| Besoin | Outils |
|---|---|
| **Build** | `pdflatex`, `xelatex`, `lualatex`, `latexmk`, `biber` |
| **Lint** | `chktex` (config `.chktexrc` fournie dans le skill), `lacheck` |
| **Formatage / fix** | `latexindent` |
| **Diff / statistiques** | `latexdiff`, `texcount` |
| **Vérif & conversion PDF** | `qpdf`, `ghostscript` (`gs`), `pdfinfo`/`pdftoppm` (poppler), `imagemagick` (`convert`) |
| **Sécurité / vérif d'assets** | `clamav` (`clamscan`), `pngcheck`, `exiftool` |

## Le skill `latex-document-skill`

Skill universel (issu de
[ndpvt-web/latex-document-skill](https://github.com/ndpvt-web/latex-document-skill))
pour créer, compiler et convertir n'importe quel document en PDF professionnel.

- **Templates** (`assets/templates/`, 30 fichiers) : CV/résumés (ATS, technique,
  exécutif, académique…), lettres (motivation, formelle, mail-merge), rapports,
  factures, articles académiques, thèses, présentations Beamer, posters
  scientifiques, examens, livres, fiches mémo (*cheatsheets*), formulaires PDF
  remplissables, documents à contenu conditionnel, `references.bib`.
- **Scripts** (`scripts/`) : compilation (`compile_latex.sh`), validation
  (`validate_latex.py`, `latex_package_check.sh`), lint (`latex_lint.sh`), diff
  (`latex_diff.sh`), comptage de mots (`latex_wordcount.sh`), graphiques
  (`generate_chart.py`), tables depuis CSV (`csv_to_latex.py`), mail-merge
  (`mail_merge.py`), diagrammes (Mermaid / Graphviz / PlantUML), opérations PDF
  (fusion, extraction, optimisation, chiffrement, formulaires), conversion
  Pandoc (`convert_document.sh`).
- **Guides** (`references/`) : bonnes pratiques, bibliographie, beamer, posters,
  tables/images, polices, débogage, accessibilité, etc.

## Le skill `tailored-resume-generator`

Skill d'**optimisation de CV** (issu de
[ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills))
qui agit sur le **contenu**, pas la mise en forme : il analyse une offre d'emploi,
réorganise et met en avant l'expérience pertinente, intègre naturellement les
mots-clés ATS, et signale les manques à combler.

Il est **complémentaire** de `latex-document-skill` :

> **`tailored-resume-generator`** décide *quoi dire* (contenu adapté au poste) →
> **`latex-document-skill`** décide *comment le rendre* (PDF dans ton style) →
> métadonnées + vérifs (voir [REFERENCEMENT.md](CV_Corentin_Michel/REFERENCEMENT.md)).

## Installer l'outillage manuellement

Dans une session Claude Code **web**, le hook `SessionStart` installe tout
automatiquement. En local / autre environnement :

```bash
# Via le hook (Debian/Ubuntu, idempotent) :
CLAUDE_CODE_REMOTE=true CLAUDE_PROJECT_DIR="$PWD" .claude/hooks/session-start.sh

# ou via le setup du skill (multi-distributions) :
bash .claude/skills/latex-document-skill/setup.sh
bash .claude/skills/latex-document-skill/setup.sh --check
```

## Crédits & licence

- `CV_Corentin_Michel/` : données personnelles de Corentin Michel — exemple
  réutilisable, **pas** les données.
- `.claude/skills/latex-document-skill/` : voir le dépôt d'origine
  [ndpvt-web/latex-document-skill](https://github.com/ndpvt-web/latex-document-skill)
  pour la licence et les crédits.

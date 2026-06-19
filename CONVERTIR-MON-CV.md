# Convertir son CV en LaTeX (prompt prêt à l'emploi)

Ce dépôt fournit un outillage LaTeX complet et deux skills complémentaires :
`tailored-resume-generator` (optimisation du **contenu** : adaptation à une offre,
mots-clés ATS) et `latex-document-skill` (mise en forme : production du **PDF**).
Voici un **prompt à copier-coller dans Claude Code** pour faire convertir *ton*
CV en LaTeX **en gardant exactement ton style visuel**, le compiler en PDF, et
recevoir un rapport de ce qu'il reste à ajuster. Tu peux aussi (optionnel) lui faire
**optimiser le contenu** pour une offre précise.

## Mode d'emploi

1. Clone ce dépôt et ouvre une session **Claude Code** à sa racine :
   ```bash
   git clone https://github.com/SKOHscripts/latex_things.git
   cd latex_things
   # puis lance Claude Code dans ce dossier
   ```
   - En session **web**, l'outillage LaTeX s'installe tout seul (hook `SessionStart`).
   - En local, fais d'abord installer les outils : `bash .claude/skills/latex-document-skill/setup.sh`.
2. Aie ton **CV actuel** sous la main (PDF, Word/DOCX, ou image PNG/JPG) pour le joindre.
3. (Optionnel) Si tu veux **optimiser** ton CV pour un poste précis, prépare aussi
   le texte de **l'offre d'emploi** à coller.
4. Colle le prompt ci-dessous, et **joins ton CV** au message.

---

## Le prompt

> Copie tout le bloc ci-dessous dans Claude Code (et joins ton CV actuel au message).

```text
Tu travailles dans un clone du dépôt « latex_things », qui embarque un outillage
LaTeX complet et DEUX skills : `latex-document-skill` (conversion PDF→LaTeX, templates,
compilation/lint/vérification) et `tailored-resume-generator` (optimisation du contenu
d'un CV pour une offre : priorisation, mots-clés ATS, recommandations). Avant de
commencer, lis : `CLAUDE.md`, `README.md`, `CV_Corentin_Michel/REFERENCEMENT.md`,
`.claude/skills/latex-document-skill/SKILL.md` et
`.claude/skills/tailored-resume-generator/SKILL.md`.

OBJECTIF
Convertir MON CV actuel (que je joins à ce message) en LaTeX, en REPRODUISANT
FIDÈLEMENT son style visuel. C'est LaTeX qui doit s'adapter à MON CV — surtout ne
copie pas le style du CV d'exemple du dépôt (CV_Corentin_Michel) et n'applique pas
un template générique. Le résultat doit ressembler à mon CV, pas l'inverse.
Si je joins une OFFRE D'EMPLOI, optimise aussi le CONTENU pour ce poste (voir étape 5b) ;
sinon, reproduis le contenu tel quel.

ÉTAPES
1. Vérifie l'outillage : `pdflatex`, `latexmk`, `chktex`, `latexindent`, `qpdf`,
   `exiftool`, `pdftoppm` doivent être disponibles. Si non, lance le hook
   (`CLAUDE_CODE_REMOTE=true CLAUDE_PROJECT_DIR="$PWD" .claude/hooks/session-start.sh`)
   ou `bash .claude/skills/latex-document-skill/setup.sh`.
2. Si je n'ai pas joint mon CV, demande-le-moi avant d'aller plus loin. Sers-t'en
   comme RÉFÉRENCE VISUELLE.
3. Analyse précisément la source : mise en page (colonnes, en-tête, photo), polices,
   couleurs (donne les codes hex), ordre et intitulés des sections, icônes, listes,
   espacements, marges. Appuie-toi sur les guides de conversion PDF→LaTeX du skill.
4. Recrée le CV en LaTeX dans un NOUVEAU dossier `CV_<MonNom>/` :
   - reproduis le style au plus près (polices équivalentes si la police exacte est
     propriétaire — signale-le) ;
   - garde le texte SÉLECTIONNABLE (jamais une image scannée du CV) ;
   - ne réutilise les macros/classes du dépôt que si elles servent MON style.
5. NE PAS inventer de contenu : reprends exactement le texte de mon CV. Si un élément
   est illisible/ambigu dans la source, demande-moi.
5b. OPTIMISATION (uniquement si je joins une offre d'emploi) : utilise le skill
   `tailored-resume-generator` pour analyser l'offre et adapter le CONTENU — réordonner
   et reformuler mes expériences pour mettre en avant le pertinent, intégrer
   NATURELLEMENT les mots-clés de l'offre (pas de bourrage, pas de mensonge), et
   repérer les manques. Contraintes : ne change PAS la mise en page / le style ;
   n'invente AUCUNE expérience ou compétence ; présente-moi d'abord un RÉSUMÉ des
   changements proposés (avant/après) et attends ma validation avant d'intégrer.
6. Applique les bonnes pratiques de `CV_Corentin_Michel/REFERENCEMENT.md` :
   - métadonnées PDF via `\hypersetup{...}` + `\usepackage{hyperxmp}` + `pdflang` ;
   - mots-clés PERTINENTS tirés de mon contenu (compétences, intitulés), sans bourrage ;
   - nom de fichier `Prenom_Nom_CV.pdf` ;
   - viser < 1 Mo (optimiser la photo / les images).
7. Compile avec `latexmk -pdf` (PLUSIEURS passes — une seule passe peut fausser le
   nombre de pages avec des mises en page type paracol/tikz).
8. Vérifie et itère :
   - `chktex` (avec `-l .claude/skills/latex-document-skill/.chktexrc`) et `latexindent` ;
   - `qpdf --check` sur le PDF ;
   - génère des aperçus PNG (`pdftoppm -png -r 150`) et COMPARE côte à côte avec mon
     CV d'origine ; recommence jusqu'à ce que le rendu corresponde ;
   - passe `pngcheck`/`exiftool` sur les images ajoutées.
9. LIVRABLES, à me fournir à la fin :
   - le PDF compilé (donne le chemin et un aperçu) ET les sources `.tex` ;
   - un RAPPORT clair indiquant :
     * le degré de fidélité (ce qui correspond, ce qui n'a pas pu être reproduit
       exactement et pourquoi — ex. police propriétaire, effet graphique),
     * les polices/paquets à installer si besoin,
     * le contenu à vérifier ou mettre à jour de mon côté,
     * si optimisation : le résumé des changements de contenu et les mots-clés de
       l'offre couverts / non couverts (manques à combler),
     * les suggestions issues des bonnes pratiques (métadonnées, nommage, taille,
       accessibilité / PDF tagué).
10. Dis-moi explicitement CE QUE JE DOIS RELIRE OU MODIFIER.

CONTRAINTES
- Mes données sont personnelles : ne les publie pas, ne committe/pousse rien sans me
  le demander.
- En cas de doute sur le style ou le contenu, pose-moi la question plutôt que de
  deviner.
```

---

## Astuce

Plus la source est nette, meilleure est la conversion : si tu as ton CV en **PDF
vectoriel** (texte sélectionnable) plutôt qu'en image, le rendu sera bien plus fidèle.

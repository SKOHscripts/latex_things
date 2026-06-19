# Bien référencer son CV PDF — bonnes pratiques

Guide synthétique pour rendre un CV PDF **identifiable, trouvable et bien parsé**
(par un recruteur, un ATS, un moteur de recherche bureau ou un outil IA). Issu d'une
revue des pratiques courantes (sources en bas de page) — à jour 2025‑2026.

## ⚠️ La réalité à connaître d'abord

Les **ATS** (logiciels de tri des candidatures) modernes **lisent le texte du corps
du document, pas les champs de métadonnées**. Bourrer des mots‑clés dans les
métadonnées **n'améliore pas** le score ATS, et le keyword‑stuffing (texte blanc
caché, mots hors‑sujet) peut être détecté et pénalisé.

➡️ Les métadonnées servent donc surtout à : l'**identification** dans les visionneuses
PDF, l'**indexation** par la recherche bureau / web, et le **contexte** pour les
outils IA — pas à « tromper » un ATS. Les mots‑clés qui comptent doivent apparaître
**naturellement dans le texte visible** du CV.

## 1. Nom du fichier

C'est le premier « référencement », souvent négligé.

- **Format recommandé** : `Prenom_Nom_CV.pdf` ou `Prenom_Nom_Poste_CV.pdf`
  (ex. `Corentin_Michel_CV.pdf`, `Corentin_Michel_Ingenieur_Calcul_Scientifique_CV.pdf`).
- **Inclure** : prénom + nom + le mot « CV »/« Resume » ; éventuellement le poste visé
  (signale une candidature ciblée).
- **Éviter** : `final`, `v2`, `draft`, `2021`, `cv-corrigé-vraiment-final`… → perçus
  comme négligés.
- Préférer `_` ou `-` aux espaces (URLs/serveurs plus robustes).

## 2. Métadonnées PDF (Info + XMP)

Un PDF a **deux** systèmes de métadonnées — il vaut mieux renseigner **les deux** :

1. **Dictionnaire d'information** (historique) : `Title`, `Author`, `Subject`,
   `Keywords`. C'est ce que remplit déjà ce CV via `\hypersetup{...}`.
2. **XMP** (XML/RDF, schéma **Dublin Core** : `dc:title`, `dc:creator`,
   `dc:description`) : exigé par PDF 2.0, et c'est souvent **lui** que lisent les
   indexeurs robustes et certains outils IA.

En LaTeX, le paquet **`hyperxmp`** synchronise automatiquement le XMP avec les valeurs
de `hyperref` — il suffit de l'ajouter :

```latex
\usepackage{hyperxmp}   % à charger ; hyperxmp reprend les champs de \hypersetup
\hypersetup{
  pdftitle={CV - Corentin Michel - Ingénieur calcul scientifique Python},
  pdfauthor={Corentin Michel},
  pdfsubject={Curriculum Vitae - Ingénieur calcul scientifique et neutronique},
  pdfkeywords={Python, calcul scientifique, neutronique, ...}
}
```

Bonnes pratiques pour les champs :
- **Title** : « CV — Prénom Nom — Intitulé de poste » (lisible, identifiant).
- **Author** : ton nom complet uniquement.
- **Subject** : une phrase décrivant le document.
- **Keywords** : 10‑20 termes **pertinents** (compétences, technologies, intitulés de
  poste), séparés par des virgules. Pas de termes hors‑sujet.

## 3. Taille et image

- Viser **< 1 Mo** : certains ATS tronquent les gros fichiers. Ce CV pèse ~1,7 Mo à
  cause de la photo → compresser l'image (ex. `pictures/Corentin_pp.png`) ou utiliser
  `scripts/pdf_optimize.sh` du skill réduit nettement le poids.
- Garder le CV **sélectionnable** (vrai texte), jamais une image scannée du CV.

## 4. Accessibilité — PDF « tagué »

Un PDF **structuré/tagué** est mieux lu par les lecteurs d'écran **et** par les
parseurs (ATS, IA), car la hiérarchie (titres, listes) est explicite.

- Depuis **TeX Live 2025**, `\DocumentMetadata{pdfstandard=ua-2, pdfversion=2.0}`
  (tout en **première ligne**, avant `\documentclass`) active le balisage PDF/UA ;
  le support complet passe par **LuaLaTeX**.
- Utiliser des **sections sémantiques** (`\section`, `\subsection`), `hyperref` pour
  des liens cliquables, et de l'**alt text** sur les images.
- Pour l'archivage durable : profil **PDF/A**.
- Vérifier la conformité avec **veraPDF** ou **PAC** (PDF Accessibility Checker).

> Note : ce CV utilise une classe custom (`modernsimplecv`) en pdfLaTeX avec une mise
> en page graphique dense (deux colonnes, tcolorbox, tikz). Le balisage complet
> PDF/UA demanderait LuaLaTeX et des ajustements ; à considérer si l'accessibilité
> devient un objectif explicite.

## 5. Cohérence de la présence en ligne

Le « référencement » d'un CV dépasse le fichier : viser la **cohérence** entre le CV,
LinkedIn et GitHub (même nom, mêmes intitulés, mêmes mots‑clés). C'est ce qui
ressort le mieux pour un recruteur qui te cherche, et pour un outil IA qui recoupe
les sources.

## 6. Vérifier le résultat

```bash
pdfinfo "CV - Corentin Michel.pdf"                 # Title/Author/Subject/Keywords
exiftool "CV - Corentin Michel.pdf"                # Info + XMP (dc:*)
exiftool -XMP-dc:all "CV - Corentin Michel.pdf"    # XMP Dublin Core spécifiquement
verapdf --flavour ua2 "CV - Corentin Michel.pdf"   # conformité accessibilité (si installé)
```

## En résumé

| Levier | Impact | Action |
|---|---|---|
| Nom de fichier | Élevé (humain) | `Prenom_Nom_CV.pdf` |
| Texte visible + mots‑clés naturels | **Élevé (ATS)** | Termes du poste dans le corps |
| Métadonnées Info + XMP | Moyen (recherche, IA, identification) | `\hypersetup` + `hyperxmp` |
| Taille < 1 Mo, texte sélectionnable | Moyen (ATS) | Compresser l'image |
| PDF tagué / accessible | Variable | `\DocumentMetadata` + LuaLaTeX |
| Cohérence CV ↔ LinkedIn ↔ GitHub | Élevé | Mêmes nom/intitulés/mots‑clés |

## Sources

- [Resumly — Importance of metadata in resume uploads](https://www.resumly.ai/blog/importance-of-metadata-in-resume-uploads)
- [Resumly — Best practices for PDF resumes to avoid ATS errors](https://www.resumly.ai/blog/best-practices-for-pdf-resumes-to-avoid-ats-errors)
- [Resume Optimizer Pro — ATS resume best practices 2026](https://resumeoptimizerpro.com/blog/ats-friendly-resume-tips)
- [Jobscan — Resume file name](https://www.jobscan.co/blog/writing-a-resume-pay-attention-to-the-file-name/)
- [VisualCV — How to name your resume file](https://www.visualcv.com/blog/how-to-name-your-resume-file/)
- [Overleaf — Introduction to tagged PDF files](https://www.overleaf.com/learn/latex/An_introduction_to_tagged_PDF_files%3A_internals_and_the_challenges_of_accessibility)
- [TeX Users Group — Accessibility and PDF standards](https://www.tug.org/twg/accessibility/)
- [PDF Association — PDF/A metadata: XMP, RDF & Dublin Core](https://pdfa.org/wp-content/until2016_uploads/2011/08/pdfa_metadata-2b.pdf)

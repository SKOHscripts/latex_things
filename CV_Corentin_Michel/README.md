# CV — Corentin Michel

Sources LaTeX du CV de Corentin Michel.

## Compilation

Le document se compile avec **pdfLaTeX** :

```bash
pdflatex "CV - Corentin Michel.tex"
```

Packages requis (disponibles dans une distribution TeX Live complète) :
`AlegreyaSans`, `beuron`, `fontawesome`, `paracol`, `tcolorbox`, `tikz`,
`smartdiagram`, `titlesec`, `babel` (français), entre autres.

## Contenu

- `CV - Corentin Michel.tex` — document principal
- `modernsimplecv.cls` / `modernsimplecv.sty` — classe et style du CV
- `Reference letter.pdf` — lettre de référence incluse en dernière page
- `pictures/` — uniquement les images réellement utilisées par le CV

> Les fichiers non utilisés présents dans l'archive d'origine (images
> inutilisées, polices `.ttf` non chargées par le document, etc.) ont été
> retirés pour ne garder que le strict nécessaire à la compilation.

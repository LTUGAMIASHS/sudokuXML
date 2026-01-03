# Projet Sudoku

Le rapport sur notre travail se trouve dans Rapport_XML.pdf
Le répertoire annexe contient les scripts python que nous avons utilisés pour générer des sudoku en xml

## Objectif 1 et 2 : Schema XSD

Le schema se trouve dans le fichier schema_sudoku.xsd

Test avec un sudoku valide :

    xmllint --schema schema_sudoku.xsd sudoku_entier_valide.xml

Test avec un sudoku mal formé (80 cellules)

    xmllint --schema schema_sudoku.xsd sudoku_mal_forme1.xml

Test avec un sudoku mal formé (19 dans une cellule)

    xmllint --schema schema_sudoku.xsd sudoku_mal_forme2.xml

## Objectif 3

Feuille de style xslt : objectif3.xsl

Test avec un sudoku enter et valide :

    xsltproc objectif3.xsl sudoku_entier_valide.xml > img.svg

Test avec un sudoku entier et non valide :

    xsltproc objectif3.xsl sudoku_entier_invalide.xml > img.svg

Test avec un sudoku incomplet et non valide :

    xsltproc objectif3.xsl sudoku_incomplet_invalide.xml > img.svg

Test avec un sudoku incomplet et valide :

    xsltproc objectif3.xsl sudoku_incomplet_valide.xml > img.svg

## Objectif 4

Se rendre dans le répertoire objectif4

    cd objectif4

Test pour 1

    xsltproc un.xsl un.xml > img.svg

Test pour 2

    xsltproc deux.xsl deux.xml > img.svg

Test pour 3

    xsltproc trois.xsl trois.xml > img.svg

Test pour 4

    xsltproc quatre.xsl quatre.xml > img.svg

Test pour 5

    xsltproc cinq.xsl cinq.xml > img.svg

Test pour 6

    xsltproc six.xsl six.xml > img.svg

Test pour 7

    xsltproc sept.xsl sept.xml > img.svg

Test pour 8

    xsltproc huit.xsl huit.xml > img.svg

Test pour 9

    xsltproc neuf.xsl neuf.xml > img.svg

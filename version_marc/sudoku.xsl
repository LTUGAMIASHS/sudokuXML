<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns="http://www.w3.org/2000/svg">

    <xsl:output method="xml" indent="yes" media-type="image/svg+xml"/>

   <!-- Ces cles permettront de verifier les doublons dans une colonne, une region et une ligne -->
    <xsl:key name="cols" match="cell" use="concat(@col, '-', text())"/>

    <xsl:key name="regions" match="cell" use="concat(@region, '-', text())"/>

    <xsl:key name="rows" match="cell" use="concat(../@index, '-', text())"/>



    <xsl:template match="/sudoku">
    <h1>Grille de Sudoku- Projet XML</h1>
        <svg width="500" height="600" viewBox="0 0 500 600">
           <!-- bon style minimal hein, on peut ameliorer si tu veux -->
            <style>
                .cell-rect { fill: white; stroke: black; stroke-width: 1; }
                .text { font-family: Arial; font-size: 20px; text-anchor: middle; dominant-baseline: middle; }
                .status { font-family: Arial; font-size: 24px; font-weight: bold; text-anchor: middle; }
                .thick-border { fill: none; stroke: black; stroke-width: 3; }
            </style>

            <g transform="translate(50, 50)">
                
                
                <xsl:apply-templates select="grille/row/cell"/>

              
                <!-- Contour global --> 
                <rect x="0" y="0" width="450" height="450" class="thick-border"/>
                <!-- Lignes verticales épaisses (après la col 3 et 6) -->
                <line x1="150" y1="0" x2="150" y2="450" class="thick-border"/>
                <line x1="300" y1="0" x2="300" y2="450" class="thick-border"/>
                <!-- Lignes horizontales épaisses (après la ligne 3 et 6) -->
                <line x1="0" y1="150" x2="450" y2="150" class="thick-border"/>
                <line x1="0" y1="300" x2="450" y2="300" class="thick-border"/>
            </g>

            <!-- aFFICHER LE STATUT (Gagnant / Incorrect / Non gagnant) -->
            <text x="250" y="550" class="status">
                <xsl:call-template name="verifier-statut"/>
            </text>
        </svg>
    </xsl:template>

 
    <xsl:template match="cell"> 
        <!-- Calcul des coordonnées X et Y -->
        <!-- X = (colonne - 1) * 50 -->
        <xsl:variable name="x" select="(@col - 1) * 50"/>
        <!-- Y = (ligne - 1) * 50. Note: on récupère l'index de la ligne parente -->
        <xsl:variable name="y" select="(../@index - 1) * 50"/>

        <!-- Dessiner le carré de la cellule -->
        <rect x="{$x}" y="{$y}" width="50" height="50" class="cell-rect"/>

        <!-- Afficher le chiffre si la cellule n'est pas vide -->
        <xsl:if test="text() != ''">
            <!-- Le texte est centré dans le carré (+25) -->
            <text x="{$x + 25}" y="{$y + 25}" class="text">
                <xsl:value-of select="."/>
            </text>
        </xsl:if>
    </xsl:template>

  
    <xsl:template name="verifier-statut">
        
        
        <xsl:variable name="erreurs">
            <!-- On parcourt toutes les cellules remplies --> 
            <xsl:for-each select="//cell[text() != '']">
                <!-- On vérifie si la valeur existe déjà dans la même colonne, ligne ou région -->
                <!-- count(...) > 1 signifie qu'il y a un doublon -->
                <xsl:if test="count(key('cols', concat(@col, '-', text()))) > 1 or 
                              count(key('rows', concat(../@index, '-', text()))) > 1 or 
                              count(key('regions', concat(@region, '-', text()))) > 1">
                    <xsl:text>1</xsl:text> 
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <!-- Compter les cases vides -->
        <xsl:variable name="cases-vides" select="count(//cell[not(text()) or text() = ''])"/>

        <!-- Déterminer le statut final -->
        <xsl:choose>
            <!-- Cas 1 : Il y a des erreurs (doublons) -->
            <xsl:when test="string-length($erreurs) > 0">
                <xsl:attribute name="fill">red</xsl:attribute>
                <xsl:text>Configuration inexacte</xsl:text>
            </xsl:when>
            
            <!-- Cas 2 : Pas d'erreur, mais il reste des cases vides -->
            <xsl:when test="$cases-vides > 0">
                <xsl:attribute name="fill" >orange</xsl:attribute>
                <xsl:text>Configuration exact non gagnante</xsl:text>
            </xsl:when>
            
            <!-- Cas 3 : Pas d'erreur et aucune case vide -> GAGNÉ ! -->
            <xsl:otherwise>
                <xsl:attribute name="fill">green</xsl:attribute>
                <xsl:text>Configuration gagnante</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>

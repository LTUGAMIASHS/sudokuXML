<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" indent="yes" />

    <xsl:template match="/sudoku">
        <html>
            <body>
                <h1>SUDOKU</h1>
                <!-- La variable erreur contiendra à la fin les infos utiles -->
                <xsl:variable name="erreur">
                    <!-- Appel du template récursif -->
                    <xsl:call-template name="while">
                        <xsl:with-param name="pos" select='1'/>
                        <xsl:with-param name="conflit" select="'non'" />
                        <xsl:with-param name="vide" select="'non'" />

                    </xsl:call-template>
                </xsl:variable>


                <!-- Affichage des informations -->
                <xsl:choose>
                    <xsl:when test="contains($erreur, 'vide')">
                        <h5>La grille est incomplète</h5>
                    </xsl:when>
                    <xsl:otherwise>
                        <h5>La grille est complète</h5>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="contains($erreur, 'conflit')">
                        <h5>La grille contient une ou des erreur(s)</h5>
                    </xsl:when>
                    <xsl:otherwise>
                        <h5>La grille ne contient pas d'erreur</h5>
                    </xsl:otherwise>
                </xsl:choose>

                <!-- Affichage de la grille -->
                <xsl:call-template name="draw_svg" />

            </body>
        </html>
    </xsl:template>


    <xsl:template name="while">
        <xsl:param name="pos"/>
        <xsl:param name="conflit"/>
        <xsl:param name="vide"/>

        <!-- Utilisation de contains pour éviter des erreurs dûes à la mise en forme auto -->
        <xsl:if test="($pos &lt; 80) and not (contains($conflit, 'oui')) and not (contains($vide,'oui'))">

            <!-- Pas encore d'erreur ET vide il faut continuer-->
            <!-- Traiement la cellule à la position $pos, -->
            <xsl:variable name="stop">
                <xsl:if test="cell[position() = $pos]">
                    <xsl:apply-templates select="cell[position() = $pos ]">
                        <!-- renvoie vers le template cell avec comme contexte la cell à position $pos -->
                        <xsl:with-param name="pos" select="$pos"/>
                        <!-- position dans /sudoku de la cellule -->
                        <xsl:with-param name="conflit" select="$conflit" />
                        <xsl:with-param name="vide" select="$vide" />
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:variable>


            <!--Permet de mettre 'conflit' et 'vide' dans $erreur si il y a conflit ou une cell vide-->
            <xsl:value-of select='$stop'/>

            <!-- Utilisation de contains pour éviter des erreurs dûes à la mise en forme auto -->
            <xsl:variable name="define_conflit">
                <xsl:choose>
                    <xsl:when test="contains($conflit,'oui') or contains($stop, 'conflit')">oui</xsl:when>
                    <xsl:otherwise>non</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="define_vide">
                <xsl:choose>
                    <xsl:when test="contains($vide,'oui') or contains($stop, 'vide')">oui</xsl:when>
                    <xsl:otherwise>non</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>


            <!-- Appel récursif  -->
            <xsl:call-template name="while">
                <xsl:with-param name="pos" select="$pos +1 "/>
                <xsl:with-param name="conflit" select="$define_conflit"/>
                <xsl:with-param name="vide" select="$define_vide"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>



    <xsl:template match="cell">
        <xsl:param name="pos"/>
        <xsl:param name="conflit"/>
        <xsl:param name="vide"/>
        <value-of select="$pos" />

        <xsl:choose>
            <xsl:when test="not (.='') and contains($conflit,'non')">
                <!-- Il faut encore chercher des erreurs -->
                <!-- On definie les variables pour la cellule en cours -->
                <xsl:variable name="val1">
                    <xsl:value-of select="." />
                </xsl:variable>
                <xsl:variable name="row1">
                    <xsl:value-of select="floor(($pos - 1)  div 9)+1"/>
                </xsl:variable>
                <xsl:variable name="col1">
                    <xsl:value-of select="($pos -1 ) mod 9 + 1"/>
                </xsl:variable>
                <xsl:variable name="zone1">
                    <xsl:value-of select="(floor(($row1 - 1 ) div 3) * 3 + 1 + floor(($col1 - 1) div 3))" />
                </xsl:variable>
                <!-- Parcours des cellules soeurs suivantes avec un template récursif-->
                <xsl:call-template name="siblings">
                    <xsl:with-param name="val1" select="$val1"/>
                    <xsl:with-param name="row1" select="$row1"/>
                    <xsl:with-param name="col1" select="$col1"/>
                    <xsl:with-param name="zone1" select="$zone1"/>
                    <xsl:with-param name="pos2" select="$pos + 1"/>
                </xsl:call-template>
            </xsl:when>

            <xsl:when test="contains($vide,'non') and (.='')">
                vide
            </xsl:when>
        </xsl:choose>
    </xsl:template>



    <xsl:template name="siblings">
        <xsl:param name="val1"/>
        <xsl:param name="row1"/>
        <xsl:param name="col1"/>
        <xsl:param name="zone1"/>
        <xsl:param name="pos2"/>
        <xsl:variable name="stop2">
            <!-- Definition des variables -->
            <xsl:variable name="val2">
                <xsl:value-of select="/sudoku/cell[position() = $pos2]" />
            </xsl:variable>
            <!-- Pas besoin d'aller plus loin sur les valeurs sont différentes -->
            <xsl:if test="$val1 = $val2">
                <xsl:variable name="row2">
                    <xsl:value-of select="floor(($pos2 - 1)  div 9)+1"/>
                </xsl:variable>
                <xsl:variable name="col2">
                    <xsl:value-of select="($pos2 -1 ) mod 9 + 1"/>
                </xsl:variable>
                <xsl:variable name="zone2">
                    <xsl:value-of select="(floor(($row2 - 1 ) div 3) * 3 + 1 + floor(($col2 - 1) div 3))" />
                </xsl:variable>

                <!-- Est-ce qu'il y a conflit ? -->
                <xsl:if test="($row1 = $row2) or ($col1 = $col2) or ($zone1 = $zone2)">
                        conflit
                    <xsl:variable name="chaine" select="concat($row1,';',$col1,' avec ',$row2,';',$col2)" />
                    <xsl:value-of select="$chaine"/>
                </xsl:if>
            </xsl:if>
        </xsl:variable>

        <!-- Permet de mettre 'conflit' si nécessaire dans stop -->
        <xsl:value-of select="$stop2"/>

        <!-- Si pas d'erreur on continue -->
        <xsl:if test="($pos2 &lt; 81) and ($stop2='')">
            <xsl:call-template name="siblings">
                <xsl:with-param name="val1" select="$val1"/>
                <xsl:with-param name="row1" select="$row1"/>
                <xsl:with-param name="col1" select="$col1"/>
                <xsl:with-param name="zone1" select="$zone1"/>
                <xsl:with-param name="pos2" select="$pos2 + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


    <xsl:template name="draw_svg">
        <div>
            <svg width="500" height="500"
                xmlns="http://www.w3.org/2000/svg">
                <xsl:for-each select="cell">
                    <xsl:variable name="pos" select="position()" />
                    <xsl:variable name="row">
                        <xsl:value-of select="floor(($pos - 1)  div 9)+1"/>
                    </xsl:variable>
                    <xsl:variable name="col">
                        <xsl:value-of select="($pos -1 ) mod 9 + 1"/>
                    </xsl:variable>
                    <xsl:variable name="rowSVG">
                        <xsl:value-of select="($row -1) * 50"/>
                    </xsl:variable>
                    <xsl:variable name="colSVG">
                        <xsl:value-of select="($col -1) * 50"/>
                    </xsl:variable>

                    <rect width="50" height="50" x="{$colSVG+10}" y="{$rowSVG+10}" style="fill:rgb(255,255,255);stroke-width:3;stroke:black" />
                    <text x="{$colSVG +26}" y="{$rowSVG +45}" font-size="2em" fill="black">
                        <xsl:value-of select="." />
                    </text>
                </xsl:for-each>
                <line x1="160" y1="10" x2="160" y2 ="460" style="stroke:black;stroke-width:12"/>
                <line x1="310" y1="10" x2="310" y2 ="460" style="stroke:black;stroke-width:12"/>
                <line x1="10" y1="160" x2="460" y2 ="160" style="stroke:black;stroke-width:12"/>
                <line x1="10" y1="310" x2="460" y2 ="310" style="stroke:black;stroke-width:12"/>
            </svg>
        </div>
    </xsl:template>



</xsl:stylesheet>
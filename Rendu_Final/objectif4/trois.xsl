<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" indent="yes" />
    <xsl:variable name="number" select='3' />


    <xsl:template match="/">
        <xsl:apply-templates select="sudoku" />
    </xsl:template>

    <xsl:template match="sudoku">
        <svg width="500" height="650"
            xmlns="http://www.w3.org/2000/svg">
            <title>Sudoku</title>

            <!-- Est-ce qu'il y a des conflits ? -->
            <xsl:variable name="blocked_tiles">
                <xsl:call-template name="look_for_blocked_tiles" />
            </xsl:variable>

            <!-- Affichage-->
            <text x="40" y="40" stroke="red" font-size="35">
            SUDOKU
            </text>
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

                <xsl:choose>
                    <xsl:when test="contains($blocked_tiles, concat($row,';',$col))">
                        <rect width="50" height="50" x="{$colSVG+10}" y="{$rowSVG+10+50}" style="fill:rgba(235, 10, 10, 1);stroke-width:3;stroke:black" />
                    </xsl:when>
                    <xsl:otherwise>
                        <rect width="50" height="50" x="{$colSVG+10}" y="{$rowSVG+10+50}" style="fill:rgb(255,255,255);stroke-width:3;stroke:black" />
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:choose>
                    <xsl:when test="(.='') and not (contains($blocked_tiles, concat($row,';',$col)))">
                        <text x="{$colSVG +26}" y="{$rowSVG +45+50}" font-size="2em" fill="green">
                            <xsl:value-of select="$number" />
                        </text>
                    </xsl:when>
                    <xsl:when test="not (.='')">
                        <text x="{$colSVG +26}" y="{$rowSVG +45+50}" font-size="2em" fill="black">
                            <xsl:value-of select="." />
                        </text>
                    </xsl:when>

                </xsl:choose>

            </xsl:for-each>
            <line x1="160" y1="60" x2="160" y2 ="510" style="stroke:black;stroke-width:12"/>
            <line x1="310" y1="60" x2="310" y2 ="510" style="stroke:black;stroke-width:12"/>
            <line x1="10" y1="210" x2="460" y2 ="210" style="stroke:black;stroke-width:12"/>
            <line x1="10" y1="360" x2="460" y2 ="360" style="stroke:black;stroke-width:12"/>
        </svg>
    </xsl:template>

    <xsl:template name="look_for_blocked_tiles">
        <xsl:for-each select="cell">
            <xsl:if test=".=$number">
                <!-- On definie les variables pour la cellule en cours -->
                <xsl:variable name="val1">
                    <xsl:value-of select="." />
                </xsl:variable>
                <xsl:variable name="pos1" select="position()" />
                <xsl:variable name="row1">
                    <xsl:value-of select="floor(($pos1 - 1)  div 9)+1"/>
                </xsl:variable>
                <xsl:variable name="col1">
                    <xsl:value-of select="($pos1 -1 ) mod 9 + 1"/>
                </xsl:variable>
                <xsl:variable name="zone1">
                    <xsl:value-of select="(floor(($row1 - 1 ) div 3) * 3 + 1 + floor(($col1 - 1) div 3))" />
                </xsl:variable>
                <!-- On parcours toutes les cells suivantes -->
                <xsl:for-each select="/sudoku/cell">
                    <xsl:if test=".=''">
                        <!-- Définition des variables de la cellule fille -->
                        <xsl:variable name="val2">
                            <xsl:value-of select="." />
                        </xsl:variable>
                        <xsl:variable name="pos2">
                            <xsl:value-of select="position()"/>
                        </xsl:variable>
                        <xsl:variable name="row2">
                            <xsl:value-of select="floor(($pos2 - 1)  div 9)+1"/>
                        </xsl:variable>
                        <xsl:variable name="col2">
                            <xsl:value-of select="($pos2 -1 ) mod 9 + 1"/>
                        </xsl:variable>
                        <xsl:variable name="zone2">
                            <xsl:value-of select="(floor(($row2 - 1 ) div 3) * 3 + 1 + floor(($col2 - 1) div 3))" />
                        </xsl:variable>
                        <!-- Est-ce la case a déjà été marquée comme impossible ? -->
                        <xsl:if test="not (contains(blocked_tiles, concat($row2,';',$col2)))">
                            <!-- Doit-elle l'être ? -->
                            <xsl:if test="($row1 = $row2) or ($col1 = $col2) or ($zone1 = $zone2)">
                                <xsl:variable name="chaine" select="concat($row2,';',$col2)" />
                                <xsl:value-of select="$chaine"/>
 and 
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>



</xsl:stylesheet>
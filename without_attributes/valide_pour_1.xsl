<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml" indent="yes" />
    <xsl:variable name="number" select='1' />


    <xsl:template match="/">
        <html>
            <body>
                <xsl:apply-templates select="sudoku" />
            </body>
        </html>
    </xsl:template>

    <xsl:template match="sudoku">
        <h1>SUDOKU</h1>
        <!-- Est-ce qu'il y a des conflits ? -->
        <xsl:variable name="blocked_tiles">
            <xsl:call-template name="look_for_blocked_tiles" />
        </xsl:variable>

        <xsl:value-of select="$blocked_tiles" />

        <xsl:call-template name="draw_svg">
            <xsl:with-param name="blocked_tiles" select="$blocked_tiles" />
        </xsl:call-template>


    </xsl:template>

    <xsl:template name="look_for_blocked_tiles">
    greger
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




    <xsl:template name="draw_svg">
        <xsl:param name="blocked_tiles"/>

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

                    <xsl:choose>
                        <xsl:when test="contains($blocked_tiles, concat($row,';',$col))">
                            <rect width="50" height="50" x="{$colSVG+10}" y="{$rowSVG+10}" style="fill:rgba(235, 10, 10, 1);stroke-width:3;stroke:black" />
                        </xsl:when>
                        <xsl:otherwise>
                            <rect width="50" height="50" x="{$colSVG+10}" y="{$rowSVG+10}" style="fill:rgb(255,255,255);stroke-width:3;stroke:black" />
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:choose>
                        <xsl:when test="(.='') and not (contains($blocked_tiles, concat($row,';',$col)))">
                            <text x="{$colSVG +26}" y="{$rowSVG +45}" font-size="2em" fill="green">
                                <xsl:value-of select="$number" />
                            </text>
                        </xsl:when>
                        <xsl:when test="not (.='')">
                            <text x="{$colSVG +26}" y="{$rowSVG +45}" font-size="2em" fill="black">
                                <xsl:value-of select="." />
                            </text>
                        </xsl:when>

                    </xsl:choose>

                </xsl:for-each>
                <line x1="160" y1="10" x2="160" y2 ="460" style="stroke:black;stroke-width:12"/>
                <line x1="310" y1="10" x2="310" y2 ="460" style="stroke:black;stroke-width:12"/>
                <line x1="10" y1="160" x2="460" y2 ="160" style="stroke:black;stroke-width:12"/>
                <line x1="10" y1="310" x2="460" y2 ="310" style="stroke:black;stroke-width:12"/>
            </svg>
        </div>
    </xsl:template>

</xsl:stylesheet>
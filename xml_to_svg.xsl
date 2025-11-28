<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" indent="yes" />

      

    <xsl:template match="/">
        <html>
            <body>
                <xsl:apply-templates select="sudoku" />
            </body>
        </html>
    </xsl:template>

    <xsl:template match="sudoku">
        <h1>SUDOKU

        </h1>
        <xsl:for-each select="cell">
            <xsl:variable name="row1" select="@row" />
            <xsl:variable name="col1" select="@col" />
            <xsl:variable name="val1"> <xsl:value-of select="." /> </xsl:variable>

            <xsl:for-each select="following-sibling::node()">
                <xsl:variable name="val2"> <xsl:value-of select="." /> </xsl:variable>

                <xsl:if test="($val1 = $val2) and (($row1 = @row) or ($col1 = @col)) and not ($val2 = '')"> 
                    Il y a une erreur
                </xsl:if>
            </xsl:for-each>

        </xsl:for-each>
        <div>
        <svg width="4500" height="4500"
            xmlns="http://www.w3.org/2000/svg">
            <xsl:for-each select="cell">
                <xsl:variable name="row" select="@row * 50" />
                <xsl:variable name="col" select="@col *50" />

                <rect width="50" height="50" x="{$col}" y="{$row}" style="fill:rgb(255,255,255);stroke-width:3;stroke:black" />
                
                <text x="{$col +20}" y="{$row +40}" font-size="2em" fill="black"><xsl:value-of select="."/></text>
            </xsl:for-each>
        </svg>
        </div>
        
    </xsl:template>

</xsl:stylesheet>
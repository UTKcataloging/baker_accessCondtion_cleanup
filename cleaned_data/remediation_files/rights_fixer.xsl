<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.og/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3"
    xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-5.xsd"
    exclude-result-prefixes="xs" xpath-default-namespace="http://www.loc.gov/mods/v3" version="2.0">
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- identity transform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:variable name="filename" select="collection('../modsxml/?select=*.xml')"/>
    
    <xsl:template name="main">
        <xsl:for-each select="$filename">
            <xsl:variable name="fn" select="normalize-space(tokenize(document-uri(.), '/')[last()])"/>
            <!--<xsl:value-of select="concat($fn, '&#10;')"/>-->
            <xsl:result-document href="{concat('./output/',$fn)}">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <!-- apply rights statements.org -->
    <xsl:template match="accessCondition">
        <xsl:choose>
            <xsl:when test="contains(normalize-space(lower-case(.)),'the copyright interests in this item remain with the creator. for more information, contact special collections at special@utk.edu')">
                <accessCondition type="use and reproduction" xlink:href="http://rightsstatements.org/vocab/InC/1.0/">In Copyright</accessCondition>
            </xsl:when>
            <xsl:when test="contains(normalize-space(.), normalize-space('Nashville Public Library, Special Collections owns copyright of this image. Contact  library.nashville.org for terms of use.'))">
                <note displayLabel="Attribution">Nashville Public Library, Special Collections owns copyright of this image. Contact  library.nashville.org for terms of use.</note>
                <accessCondition type="use and reproduction" xlink:href="http://rightsstatements.org/vocab/InC/1.0/">In Copyright</accessCondition>
            </xsl:when>
            <xsl:when test="contains(normalize-space(.), normalize-space('Public domain'))">
                <accessCondition type="use and reproduction" xlink:href="http://rightsstatements.org/vocab/NoC-US/1.0/">No Copyright - United States</accessCondition>
            </xsl:when>
            <xsl:when test="contains(normalize-space(.), normalize-space('No known copyright restrictions'))">
                <accessCondition type="use and reproduction" xlink:href="http://rightsstatements.org/vocab/NKC/1.0/">No Known Copyright</accessCondition>
            </xsl:when>
            <xsl:otherwise>
                <accessCondition type="use and reproduction" xlink:href="http://rightsstatements.org/vocab/InC/1.0/">In Copyright</accessCondition>
            </xsl:otherwise>
        </xsl:choose>   
    </xsl:template>
</xsl:stylesheet>
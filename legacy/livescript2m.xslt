<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
 <!--
    %LIVESCRIPT2M Convert Live Script file to a classic m-file script
    %
    % LIVESCRIPT2M(FILE) extracts, in the same directory, a MATLAB script FILE.m
    % from the Live Script file FILE.mlx
    %
    % Peter Corke (c) 2016
  -->

  <xsl:output method="html" />

  <xsl:template match="/">
    <xsl:apply-templates select="//w:body" />
  </xsl:template>

  <xsl:template match="w:body">
          <xsl:apply-templates />
  </xsl:template>


  <xsl:template match="w:p">
      <xsl:apply-templates select="w:r" />
  </xsl:template>

<!-- These elements hold typed content -->
  <xsl:template match="w:r">
    <xsl:apply-templates select="../w:pPr" />
    <xsl:apply-templates select="w:t" />
  </xsl:template>

<!-- These elements are chunks of content-->
  <xsl:template match="w:t">
      <xsl:value-of select="." />
  </xsl:template>

<!-- These elements describe the type of content-->
  <xsl:template match="w:pPr">
    <xsl:apply-templates select="w:pStyle" />
  </xsl:template>

<!-- Here we get the type of block: code, text, heading or title.
     We create the appropriate comments.
-->
  <xsl:template match="w:pStyle">
    <!-- code block -->
    <xsl:if test="@w:val='code'">
       <xsl:text>
</xsl:text>
    <!-- text block -->
    </xsl:if>
    <xsl:if test="@w:val='text'">
       <xsl:text>
        
% </xsl:text>
    <!-- heading block -->
    </xsl:if>
    <xsl:if test="@w:val='heading'">
       <xsl:text>

%% </xsl:text>
    <!-- title block -->
    </xsl:if>
    <xsl:if test="@w:val='title'">
       <xsl:text>%%%% </xsl:text>
    </xsl:if>
  </xsl:template>

<!-- Eliminate simple text formatting-->

  <xsl:template match="w:u"><xsl:value-of select="." /></xsl:template>
  <xsl:template match="w:b"><xsl:value-of select="." /></xsl:template>
  <xsl:template match="w:i"><xsl:value-of select="." /></xsl:template>
</xsl:stylesheet>

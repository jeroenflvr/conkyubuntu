<!-- fcTemp.Metric.xslt

This XSLT is used to translate an XML response from the www.google.com/ig/ XML API.

This style sheet shows all HIGH/LOW FORECAST METRIC TEMPS in the Conky Weather Section, e.g.
the high/low metric temperatures that are listed at the bottom of the 3-day forecast.

The first line (forecast day list) in the 3-day forecast is handled by: fcDayList.xslt

The second line (condition icons) in the 3-day forecast is handled by: fcConditions.xslt

Adjust the number of empty spaces (as noted below) to align the horizontal spacing of the
high/low forecast metric temperatures on your desktop.  This works in conjunction with the font
size that you chose to use in your .conkyrc file, and will require some patience to setup.  :)

This is a base adjustment.  Once you get the horizontal alignment into the ballpark, the rest
of the spacing & alignment will be handled, as usual, by making adjustments to the Weather Section
in your .conkyrc file.

NOTE:   ++ Enable the following line, in the weather.sh file, for Metric Stats:

        # cURL the Google Weather API (Metric - Celsius)
        CURLURL="http://www.google.com/ig/api?weather=${LOCID}&hl=en-gb"
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
    <xsl:output method="text" disable-output-escaping="yes" encoding="utf-8"/>
    <xsl:template match="xml_api_reply">
        <xsl:apply-templates select="weather"/>
    </xsl:template>

    <xsl:template match="weather">
        <xsl:variable name="celsius"><xsl:text>º</xsl:text></xsl:variable><!-- Sets celcius variable / adds degree symbol -->
        <xsl:for-each select="forecast_conditions[position() >= 2 ]"><!-- Selects days, other than today -->
            <xsl:value-of select="high/@data"/> <xsl:value-of select="$celsius"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="low/@data"/> <xsl:value-of select="$celsius"/>
                <xsl:if test="position() != 3">
                    <xsl:text>           </xsl:text><!-- 11 spaces. Add/subtract spaces for proper Forecast Temperature alignment -->
                </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>

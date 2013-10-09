<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:gts="http://www.isotc211.org/2005/gts"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gml="http://www.opengis.net/gml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:geonet="http://www.fao.org/geonetwork"
    xsi:schemaLocation="http://www.isotc211.org/2005/gmd http://www.isotc211.org/2005/gmd/gmd.xsd"
    version="2.0">
    
    <xsl:output method="xml" indent="yes" />
    
    <xsl:template match="/">
        <MD_Metadata>
            <fileIdentifier>
                <gco:CharacterString xmlns:srv="http://www.isotc211.org/2005/srv">
                    <xsl:copy-of select="/metadata/dataIdInfo/descKeys/thesaName[@uuidref]" />
                </gco:CharacterString>
            </fileIdentifier>
            <language>
                <gco:CharacterString>
                    <xsl:copy-of select="/metadata/dataIdInfo/dataLang/languageCode[@value]"/>
                </gco:CharacterString>
            </language>
            <characterSet>
                <MD_CharacterSetCode codeListValue="utf8"
                    codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_CharacterSetCode"
                />
            </characterSet>
            <contact>
                <CI_ResponsibleParty>
                    <organisationName>
                        <gco:CharacterString>Scholars' Lab</gco:CharacterString>
                    </organisationName>
                    <contactInfo>
                        <CI_Contact>
                            <phone>
                                <CI_Telephone>
                                    <voice>
                                        <gco:CharacterString>1-434-243-8800</gco:CharacterString>
                                    </voice>
                                </CI_Telephone>
                            </phone>
                            <address>
                                <CI_Address>
                                    <deliveryPoint>
                                        <gco:CharacterString>Alderman Library, PO Box 400113</gco:CharacterString>
                                    </deliveryPoint>
                                    <city>
                                        <gco:CharacterString>Charlottesville</gco:CharacterString>
                                    </city>
                                    <administrativeArea>
                                        <gco:CharacterString>VA</gco:CharacterString>
                                    </administrativeArea>
                                    <postalCode>
                                        <gco:CharacterString>22904-00113</gco:CharacterString>
                                    </postalCode>
                                    <country>
                                        <gco:CharacterString>USA</gco:CharacterString>
                                    </country>
                                    <electronicMailAddress>
                                        <gco:CharacterString>scholars.lab@gmail.com</gco:CharacterString>
                                    </electronicMailAddress>
                                </CI_Address>
                            </address>
                        </CI_Contact>
                    </contactInfo>
                    <role>
                        <CI_RoleCode codeListValue="pointOfContact" odeList="http://www.isotc211.org/2005/resources/codeList.xml#CI_RoleCode" />
                    </role>
                </CI_ResponsibleParty>
            </contact>
            
            <dateStamp>
                <gco:DateTime xmlns:srv="http://www.isotc211.org/2005/srv">
                    <!-- may need to calculate this from the Esri/CreaDate and Esri/CreaTime -->
                    <xsl:value-of select="current-dateTime()"/>
                </gco:DateTime>
            </dateStamp>
            
            <metadataStandardName>
                <gco:CharacterString xmlns:srv="http://www.isotc211.org/2005/srv">ISO 19115:2003/19139</gco:CharacterString>
            </metadataStandardName>
            <metadataStandardVersion>
                <gco:CharacterString xmlns:srv="http://www.isotc211.org/2005/srv">1.0</gco:CharacterString>
            </metadataStandardVersion>
            
            <referenceSystemInfo>
                <MD_ReferenceSystem>
                    <referenceSystemIdentifier>
                        <RS_Identifier>
                            <code>
                                <gco:CharacterString><xsl:apply-templates select="/metadata/Esri/DataProperties/coordRef"/></gco:CharacterString>
                            </code>
                        </RS_Identifier>
                    </referenceSystemIdentifier>
                </MD_ReferenceSystem>
            </referenceSystemInfo>
            <identificationInfo>
                <MD_DataIdentification>
                    <citation>
                        <CI_Citation>
                            <title>
                                <gco:CharacterString>Albemarle Aerial Dataset</gco:CharacterString>
                            </title>
                            <date>
                                <CI_Date>
                                    <date>
                                        <gco:DateTime><xsl:value-of select="current-dateTime()"/></gco:DateTime>
                                    </date>
                                    <dateType>
                                        <CI_DateTypeCode codeListValue="publication" codeList="http://www.isotc211.org/2005/resources/codeList.xml#CI_DateTypeCode"/>
                                    </dateType>
                                </CI_Date>
                            </date>
                            <presentationForm>
                                <CI_PresentationFormCode codeListValue="mapDigital" codeList="http://www.isotc211.org/2005/resources/codeList.xml#CI_PresentationFormCode"/>
                            </presentationForm>
                        </CI_Citation>
                    </citation>
                    
                    <abstract>
                        <gco:CharacterString><!-- todo: needs an abstract --></gco:CharacterString>
                    </abstract>
                    
                    <purpose gco:nilReason="missing">
                        <gco:CharacterString/>
                    </purpose>
                    
                    <status>
                        <MD_ProgressCode codeListValue="" codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_ProgressCode"/>
                    </status>
                    
                    <pointOfContact>
                        <CI_ResponsibleParty>
                            <organisationName>
                                <gco:CharacterString>Scholars' Lab, Alderman Library, University of Virginia Library</gco:CharacterString>
                            </organisationName>
                            <contactInfo>
                                <CI_Contact>
                                    <phone>
                                        <CI_Telephone>
                                            <voice>
                                                <gco:CharacterString>1-434-243-8800</gco:CharacterString>
                                            </voice>
                                        </CI_Telephone>
                                    </phone>
                                    <address>
                                        <CI_Address>
                                            <deliveryPoint>
                                                <gco:CharacterString>Alderman Library, PO Box 400113</gco:CharacterString>
                                            </deliveryPoint>
                                            <city>
                                                <gco:CharacterString>Charlottesville</gco:CharacterString>
                                            </city>
                                            <administrativeArea>
                                                <gco:CharacterString>VA</gco:CharacterString>
                                            </administrativeArea>
                                            <postalCode>
                                                <gco:CharacterString>22904-00113</gco:CharacterString>
                                            </postalCode>
                                            <country>
                                                <gco:CharacterString>USA</gco:CharacterString>
                                            </country>
                                            <electronicMailAddress>
                                                <gco:CharacterString>scholars.lab@gmail.com</gco:CharacterString>
                                            </electronicMailAddress>
                                        </CI_Address>
                                    </address>
                                </CI_Contact>
                            </contactInfo>
                            <role>
                                <CI_RoleCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#CI_RoleCode"
                                    codeListValue="pointOfContact"/>
                            </role>
                        </CI_ResponsibleParty>
                    </pointOfContact>
                    
                    <spatialRepresentationInfo>
                        <MD_Georectified>
                            <numberOfDimensions>
                                <gco:Integer><xsl:value-of select="/metadata/spatRepInfo/Georect/numDims" /></gco:Integer>
                            </numberOfDimensions>
                            <xsl:for-each select="/metadata/spatRepInfo/Georect/axisDimension">
                                <axisDimensionProperties>
                                    <MD_Dimension>
                                        <dimensionName>
                                            <MD_DimensionNameTypeCode
                                                codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_DimensionNameTypeCode"
                                                codeListValue="column" codeSpace="ISOTC211/19115"
                                                >column</MD_DimensionNameTypeCode>
                                        </dimensionName>
                                        <dimensionSize>
                                            <gco:Integer><xsl:value-of select="dimSize"/></gco:Integer>
                                        </dimensionSize>
                                        <resolution>
                                            <gco:Measure uom="Degree"><xsl:value-of select="dimResol/value" /></gco:Measure>
                                        </resolution>
                                    </MD_Dimension>
                                </axisDimensionProperties>
                            </xsl:for-each>
                            
                            <cellGeometry>
                                <MD_CellGeometryCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_CellGeometryCode" codeListValue="area" codeSpace="ISOTC211/19115">area</MD_CellGeometryCode>
                            </cellGeometry>
                            
                            <transformationParameterAvailability>
                                <gco:Boolean>true</gco:Boolean>
                            </transformationParameterAvailability>
                            
                            <checkPointAvailability>
                                <gco:Boolean>false</gco:Boolean>
                            </checkPointAvailability>
                            
                            
                                
                                <xsl:for-each select="/metadata/spatRepInfo/Georect/cornerPts">
                                <cornerPoints>
                                    <gml:Point gml:id="{generate-id()}">
                                        <xsl:value-of select="pos"/>
                                    </gml:Point>
                                </cornerPoints>
                                </xsl:for-each>
     
                            <centerPoint>
                                <gml:Point gml:id="{generate-id(/metadata/spatRepInfo/Georect/centerPt)}">
                                    <gml:pos><xsl:value-of select="/metadata/spatRepInfo/Georect/centerPt/pos"/></gml:pos>
                                </gml:Point>
                            </centerPoint>
                            <pointInPixel>
                                <MD_PixelOrientationCode>center</MD_PixelOrientationCode>
                            </pointInPixel>
                        </MD_Georectified>
                    </spatialRepresentationInfo>
                    <referenceSystemInfo>
                        <MD_ReferenceSystem>
                            <referenceSystemIdentifier>
                                <RS_Identifier>
                                    <code>
                                        <gco:CharacterString><xsl:value-of select="/metadata/refSysInfo/RefSystem/refSysID/identCode[@code]"/></gco:CharacterString>
                                    </code>
                                    <codeSpace>
                                        <gco:CharacterString><xsl:value-of select="/metadata/refSysInfo/RefSystem/refSysID/idCodeSpace"/></gco:CharacterString>
                                    </codeSpace>
                                    <version>
                                        <gco:CharacterString><xsl:value-of select="/metadata/refSysInfo/RefSystem/refSysID/idVersion"/></gco:CharacterString>
                                    </version>
                                </RS_Identifier>
                            </referenceSystemIdentifier>
                        </MD_ReferenceSystem>
                    </referenceSystemInfo>
                    
                    <spatialRepresentationType>
                        <MD_SpatialRepresentationTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_SpatialRepresentationTypeCode" codeListValue="grid" codeSpace="ISOTC211/19115">grid</MD_SpatialRepresentationTypeCode>
                    </spatialRepresentationType>
                    <language>
                        <LanguageCode codeList="http://www.loc.gov/standards/iso639-2/php/code_list.php" codeListValue="eng" codeSpace="ISO639-2">eng</LanguageCode>
                    </language>
                    <characterSet>
                        <MD_CharacterSetCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode" codeListValue="utf8" codeSpace="ISOTC211/19115">utf8</MD_CharacterSetCode>
                    </characterSet>
                    <environmentDescription>
                        <gco:CharacterString>Microsoft Windows 7 Version 6.1 (Build 7601) Service Pack 1; ESRI ArcGIS 10.0.5.4400</gco:CharacterString>
                    </environmentDescription>
                    
                    <extent>
                        <EX_Extent>
                            <geographicElement>
                                <EX_GeographicBoundingBox>
                                    <extentTypeCode>
                                        <gco:Boolean>true</gco:Boolean>
                                    </extentTypeCode>
                                    <westBoundLongitude>
                                        <gco:Decimal>
                                            <xsl:value-of select="/metadata/Esri/DataProperties/itemProps/nativeExtBox/westBL"/>
                                        </gco:Decimal>
                                    </westBoundLongitude>
                                    <eastBoundLongitude>
                                        <gco:Decimal><xsl:value-of select="/metadata/Esri/DataProperties/itemProps/nativeExtBox/eastBL"/></gco:Decimal>
                                    </eastBoundLongitude>
                                    <southBoundLatitude>
                                        <gco:Decimal><xsl:value-of select="/metadata/Esri/DataProperties/itemProps/nativeExtBox/southBL"/></gco:Decimal>
                                    </southBoundLatitude>
                                    <northBoundLatitude>
                                        <gco:Decimal><xsl:value-of select="/metadata/Esri/DataProperties/itemProps/nativeExtBox/northBL"/></gco:Decimal>
                                    </northBoundLatitude>
                                    
                                </EX_GeographicBoundingBox>
                            </geographicElement>
                        </EX_Extent>
                    </extent>
                    
                </MD_DataIdentification>
            </identificationInfo>
            
        </MD_Metadata>
    </xsl:template>
    
    
    <xsl:template match="coordRef">
        <xsl:variable name="readable">
            <xsl:copy-of select="translate(geogcsn, '_', ' ')"/>
        </xsl:variable>
        <xsl:value-of select="replace($readable, 'GCS ', '')"/>
    </xsl:template>
    


</xsl:stylesheet>

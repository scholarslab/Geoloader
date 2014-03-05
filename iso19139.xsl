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

    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="title"/>
    <xsl:param name="identifier"/>
    <xsl:param name="abstract"/>
    <xsl:param name="wms_address"/>
    <xsl:param name="wms_layers"/>

    <xsl:template match="/">
        <gmd:MD_Metadata>

            <gmd:fileIdentifier>
                <gco:CharacterString>
                    <xsl:value-of select="$identifier"/>
                </gco:CharacterString>
            </gmd:fileIdentifier>

            <gmd:language>
                <gco:CharacterString>
                    <xsl:copy-of select="/metadata/dataIdInfo/dataLang/languageCode[@value]"/>
                </gco:CharacterString>
            </gmd:language>

            <gmd:characterSet>
                <gmd:MD_CharacterSetCode codeListValue="utf8"
                    codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_CharacterSetCode"
                />
            </gmd:characterSet>

            <gmd:contact>
                <gmd:CI_ResponsibleParty>
                    <gmd:organisationName>
                        <gco:CharacterString>Scholars' Lab</gco:CharacterString>
                    </gmd:organisationName>
                    <gmd:contactInfo>
                        <gmd:CI_Contact>
                            <gmd:phone>
                                <gmd:CI_Telephone>
                                    <gmd:voice>
                                        <gco:CharacterString>1-434-243-8800</gco:CharacterString>
                                    </gmd:voice>
                                </gmd:CI_Telephone>
                            </gmd:phone>
                            <gmd:address>
                                <gmd:CI_Address>
                                    <gmd:deliveryPoint>
                                        <gco:CharacterString>Alderman Library, PO Box 400113</gco:CharacterString>
                                    </gmd:deliveryPoint>
                                    <gmd:city>
                                        <gco:CharacterString>Charlottesville</gco:CharacterString>
                                    </gmd:city>
                                    <gmd:administrativeArea>
                                        <gco:CharacterString>VA</gco:CharacterString>
                                    </gmd:administrativeArea>
                                    <gmd:postalCode>
                                        <gco:CharacterString>22904-00113</gco:CharacterString>
                                    </gmd:postalCode>
                                    <gmd:country>
                                        <gco:CharacterString>USA</gco:CharacterString>
                                    </gmd:country>
                                    <gmd:electronicMailAddress>
                                        <gco:CharacterString>scholars.lab@gmail.com</gco:CharacterString>
                                    </gmd:electronicMailAddress>
                                </gmd:CI_Address>
                            </gmd:address>
                        </gmd:CI_Contact>
                    </gmd:contactInfo>
                    <gmd:role>
                        <gmd:CI_RoleCode codeListValue="pointOfContact"
                            odeList="http://www.isotc211.org/2005/resources/codeList.xml#CI_RoleCode"
                        />
                    </gmd:role>
                </gmd:CI_ResponsibleParty>
            </gmd:contact>

            <gmd:metadataStandardName>
                <gco:CharacterString xmlns:srv="http://www.isotc211.org/2005/srv">ISO
                    19115:2003/19139</gco:CharacterString>
            </gmd:metadataStandardName>

            <gmd:metadataStandardVersion>
                <gmd:MD_ReferenceSystem>
                    <gmd:referenceSystemIdentifier>
                        <gmd:RS_Identifier>
                            <gmd:code>
                                <gco:CharacterString>
                                    <xsl:apply-templates
                                        select="/metadata/Esri/DataProperties/coordRef"/>
                                </gco:CharacterString>
                            </gmd:code>
                        </gmd:RS_Identifier>
                    </gmd:referenceSystemIdentifier>
                </gmd:MD_ReferenceSystem>
            </gmd:metadataStandardVersion>

            <gmd:identificationInfo>
                <gmd:MD_DataIdentification>

                    <gmd:citation>
                        <gmd:CI_Citation>
                            <gmd:title>
                                <gco:CharacterString>
                                    <xsl:value-of select="$title"/>
                                </gco:CharacterString>
                            </gmd:title>
                            <gmd:date>
                                <gmd:CI_Date>
                                    <gmd:date>
                                        <gco:DateTime>
                                            <xsl:value-of select="current-dateTime()"/>
                                        </gco:DateTime>
                                    </gmd:date>
                                    <gmd:dateType>
                                        <CI_DateTypeCode codeListValue="publication"
                                            codeList="http://www.isotc211.org/2005/resources/codeList.xml#CI_DateTypeCode"
                                        />
                                    </gmd:dateType>
                                </gmd:CI_Date>
                            </gmd:date>
                            <gmd:presentationForm>
                                <gmd:CI_PresentationFormCode codeListValue="mapDigital"
                                    codeList="http://www.isotc211.org/2005/resources/codeList.xml#CI_PresentationFormCode"
                                />
                            </gmd:presentationForm>
                        </gmd:CI_Citation>
                    </gmd:citation>

                    <gmd:abstract>
                        <gco:CharacterString>
                            <xsl:value-of select="$abstract" disable-output-escaping="yes"/>
                        </gco:CharacterString>
                    </gmd:abstract>

                    <gmd:purpose gco:nilReason="missing">
                        <gco:CharacterString/>
                    </gmd:purpose>

                    <gmd:status>
                        <gmd:MD_ProgressCode codeListValue=""
                            codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_ProgressCode"
                        />
                    </gmd:status>

                    <gmd:pointOfContact>
                        <gmd:CI_ResponsibleParty>

                            <gmd:organisationName>
                                <gco:CharacterString>Scholars' Lab, Alderman Library, University of Virginia Library</gco:CharacterString>
                            </gmd:organisationName>

                            <gmd:contactInfo>
                                <gmd:CI_Contact>
                                    <gmd:phone>
                                        <gmd:CI_Telephone>
                                            <gmd:voice>
                                                <gco:CharacterString>1-434-243-8800</gco:CharacterString>
                                            </gmd:voice>
                                        </gmd:CI_Telephone>
                                    </gmd:phone>
                                    <gmd:address>
                                        <gmd:CI_Address>
                                            <gmd:deliveryPoint>
                                                <gco:CharacterString>Alderman Library, PO Box 400113</gco:CharacterString>
                                            </gmd:deliveryPoint>
                                            <gmd:city>
                                                <gco:CharacterString>Charlottesville</gco:CharacterString>
                                            </gmd:city>
                                            <gmd:administrativeArea>
                                                <gco:CharacterString>VA</gco:CharacterString>
                                            </gmd:administrativeArea>
                                            <gmd:postalCode>
                                                <gco:CharacterString>22904-00113</gco:CharacterString>
                                            </gmd:postalCode>
                                            <gmd:country>
                                                <gco:CharacterString>USA</gco:CharacterString>
                                            </gmd:country>
                                            <gmd:electronicMailAddress>
                                                <gco:CharacterString>scholars.lab@gmail.com</gco:CharacterString>
                                            </gmd:electronicMailAddress>
                                        </gmd:CI_Address>
                                    </gmd:address>
                                </gmd:CI_Contact>
                            </gmd:contactInfo>

                            <gmd:role>
                                <gmd:CI_RoleCode
                                    codeList="http://www.isotc211.org/2005/resources/codeList.xml#CI_RoleCode"
                                    codeListValue="pointOfContact"/>
                            </gmd:role>

                        </gmd:CI_ResponsibleParty>
                    </gmd:pointOfContact>

                    <gmd:spatialRepresentationInfo>
                        <gmd:MD_Georectified>

                            <gmd:numberOfDimensions>
                                <gco:Integer>
                                    <xsl:value-of select="/metadata/spatRepInfo/Georect/numDims"/>
                                </gco:Integer>
                            </gmd:numberOfDimensions>

                            <xsl:for-each select="/metadata/spatRepInfo/Georect/axisDimension">
                                <gmd:axisDimensionProperties>
                                    <gmd:MD_Dimension>
                                        <gmd:dimensionName>
                                            <gmd:MD_DimensionNameTypeCode
                                                codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_DimensionNameTypeCode"
                                                codeListValue="column" codeSpace="ISOTC211/19115"
                                                >column</gmd:MD_DimensionNameTypeCode>
                                        </gmd:dimensionName>
                                        <gmd:dimensionSize>
                                            <gco:Integer>
                                                <xsl:value-of select="dimSize"/>
                                            </gco:Integer>
                                        </gmd:dimensionSize>
                                        <gmd:resolution>
                                            <gco:Measure uom="Degree">
                                                <xsl:value-of select="dimResol/value"/>
                                            </gco:Measure>
                                        </gmd:resolution>
                                    </gmd:MD_Dimension>
                                </gmd:axisDimensionProperties>
                            </xsl:for-each>

                            <gmd:cellGeometry>
                                <gmd:MD_CellGeometryCode
                                    codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_CellGeometryCode"
                                    codeListValue="area" codeSpace="ISOTC211/19115"
                                    >area</gmd:MD_CellGeometryCode>
                            </gmd:cellGeometry>

                            <gmd:transformationParameterAvailability>
                                <gco:Boolean>true</gco:Boolean>
                            </gmd:transformationParameterAvailability>

                            <gmd:checkPointAvailability>
                                <gco:Boolean>false</gco:Boolean>
                            </gmd:checkPointAvailability>

                            <xsl:for-each select="/metadata/spatRepInfo/Georect/cornerPts">
                                <gmd:cornerPoints>
                                    <gml:Point gml:id="{generate-id()}">
                                        <xsl:value-of select="pos"/>
                                    </gml:Point>
                                </gmd:cornerPoints>
                            </xsl:for-each>

                            <gmd:centerPoint>
                                <gml:Point
                                    gml:id="{generate-id(/metadata/spatRepInfo/Georect/centerPt)}">
                                    <gml:pos>
                                        <xsl:value-of
                                            select="/metadata/spatRepInfo/Georect/centerPt/pos"/>
                                    </gml:pos>
                                </gml:Point>
                            </gmd:centerPoint>

                            <gmd:pointInPixel>
                                <MD_PixelOrientationCode>center</MD_PixelOrientationCode>
                            </gmd:pointInPixel>

                        </gmd:MD_Georectified>
                    </gmd:spatialRepresentationInfo>

                    <gmd:referenceSystemInfo>
                        <gmd:MD_ReferenceSystem>
                            <gmd:referenceSystemIdentifier>
                                <gmd:RS_Identifier>
                                    <gmd:code>
                                        <gco:CharacterString>
                                            <xsl:value-of
                                                select="/metadata/refSysInfo/RefSystem/refSysID/identCode[@code]"
                                            />
                                        </gco:CharacterString>
                                    </gmd:code>
                                    <gmd:codeSpace>
                                        <gco:CharacterString>
                                            <xsl:value-of
                                                select="/metadata/refSysInfo/RefSystem/refSysID/idCodeSpace"
                                            />
                                        </gco:CharacterString>
                                    </gmd:codeSpace>
                                    <gmd:version>
                                        <gco:CharacterString>
                                            <xsl:value-of
                                                select="/metadata/refSysInfo/RefSystem/refSysID/idVersion"
                                            />
                                        </gco:CharacterString>
                                    </gmd:version>
                                </gmd:RS_Identifier>
                            </gmd:referenceSystemIdentifier>
                        </gmd:MD_ReferenceSystem>
                    </gmd:referenceSystemInfo>

                    <gmd:spatialRepresentationType>
                        <MD_SpatialRepresentationTypeCode
                            codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_SpatialRepresentationTypeCode"
                            codeListValue="grid" codeSpace="ISOTC211/19115"
                            >grid</MD_SpatialRepresentationTypeCode>
                    </gmd:spatialRepresentationType>

                    <gmd:language>
                        <LanguageCode
                            codeList="http://www.loc.gov/standards/iso639-2/php/code_list.php"
                            codeListValue="eng" codeSpace="ISO639-2">eng</LanguageCode>
                    </gmd:language>

                    <gmd:characterSet>
                        <gmd:MD_CharacterSetCode
                            codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode"
                            codeListValue="utf8" codeSpace="ISOTC211/19115"
                            >utf8</gmd:MD_CharacterSetCode>
                    </gmd:characterSet>

                    <gmd:environmentDescription>
                        <gco:CharacterString>Microsoft Windows 7 Version 6.1 (Build 7601) Service
                            Pack 1; ESRI ArcGIS 10.0.5.4400</gco:CharacterString>
                    </gmd:environmentDescription>

                    <gmd:extent>
                        <gmd:EX_Extent>
                            <gmd:geographicElement>
                                <gmd:EX_GeographicBoundingBox>

                                    <gmd:extentTypeCode>
                                        <gco:Boolean>true</gco:Boolean>
                                    </gmd:extentTypeCode>

                                    <gmd:westBoundLongitude>
                                        <gco:Decimal>
                                            <xsl:value-of
                                                select="/metadata/Esri/DataProperties/itemProps/nativeExtBox/westBL"
                                            />
                                        </gco:Decimal>
                                    </gmd:westBoundLongitude>

                                    <gmd:eastBoundLongitude>
                                        <gco:Decimal>
                                            <xsl:value-of
                                                select="/metadata/Esri/DataProperties/itemProps/nativeExtBox/eastBL"
                                            />
                                        </gco:Decimal>
                                    </gmd:eastBoundLongitude>

                                    <gmd:southBoundLatitude>
                                        <gco:Decimal>
                                            <xsl:value-of
                                                select="/metadata/Esri/DataProperties/itemProps/nativeExtBox/southBL"
                                            />
                                        </gco:Decimal>
                                    </gmd:southBoundLatitude>

                                    <gmd:northBoundLatitude>
                                        <gco:Decimal>
                                            <xsl:value-of
                                                select="/metadata/Esri/DataProperties/itemProps/nativeExtBox/northBL"
                                            />
                                        </gco:Decimal>
                                    </gmd:northBoundLatitude>

                                </gmd:EX_GeographicBoundingBox>
                            </gmd:geographicElement>
                        </gmd:EX_Extent>
                    </gmd:extent>

                </gmd:MD_DataIdentification>
            </gmd:identificationInfo>

            <gmd:distributionInfo>
                <gmd:MD_Distribution>
                    <gmd:transferOptions>
                        <gmd:MD_DigitalTransferOptions>
                            <gmd:onLine>
                                <gmd:CI_OnlineResource>
                                    <gmd:linkage>
                                        <gmd:URL>
                                            <xsl:value-of select="$wms_address"/>
                                        </gmd:URL>
                                    </gmd:linkage>
                                    <gmd:protocol>
                                        <gco:CharacterString>OGC:WMS-1.1.1-http-get-map</gco:CharacterString>
                                    </gmd:protocol>
                                    <gmd:name>
                                        <gco:CharacterString>
                                            <xsl:value-of select="$wms_layers"/>
                                        </gco:CharacterString>
                                    </gmd:name>
                                    <gmd:description>
                                        <gco:CharacterString>
                                            <xsl:value-of select="$title"/>
                                        </gco:CharacterString>
                                    </gmd:description>
                                </gmd:CI_OnlineResource>
                            </gmd:onLine>
                        </gmd:MD_DigitalTransferOptions>
                    </gmd:transferOptions>
                </gmd:MD_Distribution>
            </gmd:distributionInfo>

        </gmd:MD_Metadata>
    </xsl:template>

    <xsl:template match="coordRef">
        <xsl:variable name="readable">
            <xsl:copy-of select="translate(geogcsn, '_', ' ')"/>
        </xsl:variable>
        <xsl:value-of select="replace($readable, 'GCS ', '')"/>
    </xsl:template>

</xsl:stylesheet>

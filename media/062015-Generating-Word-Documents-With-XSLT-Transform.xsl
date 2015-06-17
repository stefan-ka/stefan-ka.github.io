<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
	exclude-result-prefixes="w">
	<xsl:output indent="yes" standalone="yes" encoding="UTF-8" />
	<xsl:param name="docTitle" />

	<xsl:template match="/tables">
		<w:document
			xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas"
			xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
			xmlns:o="urn:schemas-microsoft-com:office:office"
			xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
			xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
			xmlns:v="urn:schemas-microsoft-com:vml"
			xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing"
			xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
			xmlns:w10="urn:schemas-microsoft-com:office:word"
			xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
			xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml"
			xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup"
			xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk"
			xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
			xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"
			mc:Ignorable="w14 wp14">
			<w:body>
				<w:p>
					<w:pPr>
						<w:pStyle w:val="Heading1" />
					</w:pPr>
					<w:r>
						<w:t><xsl:value-of select="$docTitle"/></w:t>
					</w:r>
				</w:p>
				<w:p />
				
				<xsl:for-each select="table">
					<xsl:apply-templates select="." />
				</xsl:for-each>
				
				<w:p>
					<w:bookmarkStart w:id="0" w:name="_GoBack" />
					<w:bookmarkEnd w:id="0" />
				</w:p>
				<w:sectPr>
					<w:pgSz w:w="11906" w:h="16838" />
					<w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"
						w:header="708" w:footer="708" w:gutter="0" />
					<w:cols w:space="708" />
					<w:docGrid w:linePitch="360" />
				</w:sectPr>
			</w:body>
		</w:document>
	</xsl:template>
	
	<xsl:template match="table">
		<w:p>
			<w:pPr>
				<w:pStyle w:val="Heading2" />
			</w:pPr>
			<w:r>
				<w:t><xsl:value-of select="name" /></w:t>
			</w:r>
		</w:p>
		<w:p>
			<w:pPr>
				<w:pStyle w:val="Heading3" />
			</w:pPr>
			<w:r>
				<w:t>Beschreibung</w:t>
			</w:r>
		</w:p>
		<w:p>
			<xsl:apply-templates select="description" />
		</w:p>
		<w:p>
			<w:pPr>
				<w:pStyle w:val="Heading3" />
			</w:pPr>
			<w:r>
				<w:t>Felder</w:t>
			</w:r>
		</w:p>
		<w:p />
		<w:tbl>
			<w:tblPr>
				<w:tblStyle w:val="LightGrid-Accent1" />
				<w:tblW w:w="0" w:type="auto" />
				<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0"
					w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1" />
			</w:tblPr>
			<w:tblGrid>
				<w:gridCol w:w="1994" />
				<w:gridCol w:w="3350" />
				<w:gridCol w:w="1685" />
				<w:gridCol w:w="1409" />
				<w:gridCol w:w="804" />
			</w:tblGrid>
			<w:tr>
				<w:trPr>
					<w:cnfStyle w:val="100000000000" w:firstRow="1"
						w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:oddVBand="0"
						w:evenVBand="0" w:oddHBand="0" w:evenHBand="0"
						w:firstRowFirstColumn="0" w:firstRowLastColumn="0"
						w:lastRowFirstColumn="0" w:lastRowLastColumn="0" />
				</w:trPr>
				<w:tc>
					<w:tcPr>
						<w:cnfStyle w:val="001000000000" w:firstRow="0"
							w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:oddVBand="0"
							w:evenVBand="0" w:oddHBand="0" w:evenHBand="0"
							w:firstRowFirstColumn="0" w:firstRowLastColumn="0"
							w:lastRowFirstColumn="0" w:lastRowLastColumn="0" />
						<w:tcW w:w="1994" w:type="dxa" />
					</w:tcPr>
					<w:p>
						<w:r w:rsidRPr="002D6ECD">
							<w:t>Feldname</w:t>
						</w:r>
					</w:p>
				</w:tc>
				<w:tc>
					<w:tcPr>
						<w:tcW w:w="3350" w:type="dxa" />
					</w:tcPr>
					<w:p>
						<w:pPr>
							<w:cnfStyle w:val="100000000000" w:firstRow="1"
								w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:oddVBand="0"
								w:evenVBand="0" w:oddHBand="0" w:evenHBand="0"
								w:firstRowFirstColumn="0" w:firstRowLastColumn="0"
								w:lastRowFirstColumn="0" w:lastRowLastColumn="0" />
						</w:pPr>
						<w:r>
							<w:t>Feldbezeichnung</w:t>
						</w:r>
					</w:p>
				</w:tc>
				<w:tc>
					<w:tcPr>
						<w:tcW w:w="1685" w:type="dxa" />
					</w:tcPr>
					<w:p>
						<w:pPr>
							<w:cnfStyle w:val="100000000000" w:firstRow="1"
								w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:oddVBand="0"
								w:evenVBand="0" w:oddHBand="0" w:evenHBand="0"
								w:firstRowFirstColumn="0" w:firstRowLastColumn="0"
								w:lastRowFirstColumn="0" w:lastRowLastColumn="0" />
						</w:pPr>
						<w:proofErr w:type="spellStart" />
						<w:r>
							<w:t>Feldtyp</w:t>
						</w:r>
						<w:proofErr w:type="spellEnd" />
						<w:r>
							<w:t xml:space="preserve"> / Länge</w:t>
						</w:r>
					</w:p>
				</w:tc>
				<w:tc>
					<w:tcPr>
						<w:tcW w:w="1409" w:type="dxa" />
					</w:tcPr>
					<w:p>
						<w:pPr>
							<w:cnfStyle w:val="100000000000" w:firstRow="1"
								w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:oddVBand="0"
								w:evenVBand="0" w:oddHBand="0" w:evenHBand="0"
								w:firstRowFirstColumn="0" w:firstRowLastColumn="0"
								w:lastRowFirstColumn="0" w:lastRowLastColumn="0" />
						</w:pPr>
						<w:proofErr w:type="spellStart" />
						<w:r>
							<w:t>PeopleCode</w:t>
						</w:r>
						<w:proofErr w:type="spellEnd" />
					</w:p>
				</w:tc>
				<w:tc>
					<w:tcPr>
						<w:tcW w:w="804" w:type="dxa" />
					</w:tcPr>
					<w:p>
						<w:pPr>
							<w:cnfStyle w:val="100000000000" w:firstRow="1"
								w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:oddVBand="0"
								w:evenVBand="0" w:oddHBand="0" w:evenHBand="0"
								w:firstRowFirstColumn="0" w:firstRowLastColumn="0"
								w:lastRowFirstColumn="0" w:lastRowLastColumn="0" />
						</w:pPr>
						<w:r>
							<w:t>Key</w:t>
						</w:r>
					</w:p>
				</w:tc>
			</w:tr>
			
			<xsl:for-each select="fields/field">
				<xsl:apply-templates select="." />
			</xsl:for-each>
			
		</w:tbl>
		<w:p />
	</xsl:template>
	
	<xsl:template match="field">
		<w:tr>
			<w:trPr>
				<w:cnfStyle w:val="000000100000" w:firstRow="0"
					w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:oddVBand="0"
					w:evenVBand="0" w:oddHBand="1" w:evenHBand="0"
					w:firstRowFirstColumn="0" w:firstRowLastColumn="0"
					w:lastRowFirstColumn="0" w:lastRowLastColumn="0" />
			</w:trPr>
			<w:tc>
				<w:tcPr>
					<w:cnfStyle w:val="001000000000" w:firstRow="0"
						w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:oddVBand="0"
						w:evenVBand="0" w:oddHBand="0" w:evenHBand="0"
						w:firstRowFirstColumn="0" w:firstRowLastColumn="0"
						w:lastRowFirstColumn="0" w:lastRowLastColumn="0" />
					<w:tcW w:w="1994" w:type="dxa" />
				</w:tcPr>
				<w:p>
					<w:pPr>
						<w:rPr>
							<w:b w:val="0" />
						</w:rPr>
					</w:pPr>
					<w:r>
						<w:rPr>
							<w:b w:val="0" />
						</w:rPr>
						<w:t><xsl:value-of select="name" /></w:t>
					</w:r>
				</w:p>
			</w:tc>
			<w:tc>
				<w:tcPr>
					<w:tcW w:w="3350" w:type="dxa" />
				</w:tcPr>
				<w:p>
					<w:pPr>
						<w:cnfStyle w:val="000000100000" w:firstRow="0"
							w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:oddVBand="0"
							w:evenVBand="0" w:oddHBand="1" w:evenHBand="0"
							w:firstRowFirstColumn="0" w:firstRowLastColumn="0"
							w:lastRowFirstColumn="0" w:lastRowLastColumn="0" />
					</w:pPr>
					<w:r>
						<w:t><xsl:value-of select="description" /></w:t>
					</w:r>
				</w:p>
			</w:tc>
			<w:tc>
				<w:tcPr>
					<w:tcW w:w="1685" w:type="dxa" />
				</w:tcPr>
				<w:p>
					<w:pPr>
						<w:cnfStyle w:val="000000100000" w:firstRow="0"
							w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:oddVBand="0"
							w:evenVBand="0" w:oddHBand="1" w:evenHBand="0"
							w:firstRowFirstColumn="0" w:firstRowLastColumn="0"
							w:lastRowFirstColumn="0" w:lastRowLastColumn="0" />
					</w:pPr>
					<w:r>
						<w:t><xsl:value-of select="type" /></w:t>
					</w:r>
					<w:r>
						<w:t xml:space="preserve"> </w:t>
					</w:r>
					<w:r>
						<w:t><xsl:value-of select="length" /></w:t>
					</w:r>
				</w:p>
			</w:tc>
			<w:tc>
				<w:tcPr>
					<w:tcW w:w="1409" w:type="dxa" />
				</w:tcPr>
				<w:p>
					<w:pPr>
						<w:cnfStyle w:val="000000100000" w:firstRow="0"
							w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:oddVBand="0"
							w:evenVBand="0" w:oddHBand="1" w:evenHBand="0"
							w:firstRowFirstColumn="0" w:firstRowLastColumn="0"
							w:lastRowFirstColumn="0" w:lastRowLastColumn="0" />
					</w:pPr>
					<w:r>
						<w:t><xsl:value-of select="peoplecode" /></w:t>
					</w:r>
				</w:p>
			</w:tc>
			<w:tc>
				<w:tcPr>
					<w:tcW w:w="804" w:type="dxa" />
				</w:tcPr>
				<w:p>
					<w:pPr>
						<w:cnfStyle w:val="000000100000" w:firstRow="0"
							w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:oddVBand="0"
							w:evenVBand="0" w:oddHBand="1" w:evenHBand="0"
							w:firstRowFirstColumn="0" w:firstRowLastColumn="0"
							w:lastRowFirstColumn="0" w:lastRowLastColumn="0" />
					</w:pPr>
					<w:r>
						<w:t><xsl:value-of select="key" /></w:t>
					</w:r>
				</w:p>
			</w:tc>
		</w:tr>
	</xsl:template>
	<xsl:template match="table/description" name="lines">
		<xsl:param name="pText" select="." />
	
		<xsl:if test="string-length($pText)">
			<w:r>
				<w:t><xsl:value-of select="substring-before(concat($pText, '&#xA;'), '&#xA;')" /></w:t><w:br/>
			</w:r>
	
			<xsl:call-template name="lines">
				<xsl:with-param name="pText"
					select="substring-after($pText, '&#xA;')" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>

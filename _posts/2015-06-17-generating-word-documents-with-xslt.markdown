---
layout:     post
title:      "Generate Word Documents with XSLT"
subtitle:   "XSLT Transformation"
date:       2015-06-17 09:00:00
author:     "Stefan Kapferer"
header-img: "img/062015-generating-word-documents-with-xslt-bg.jpg"
tags:       [xml, xslt, java]
---

## Generate Word Documents with XSLT
These days I had to create a documentation of some part of a database. (tables and views)
One requirement of my boss was that the documentation had to be done in a word document.

The data I needed where all available in the database and the database-tool allows it 
to export the query results as an XML file. This brought me to the idea to automate the creation of the document with XSLT because a Word Document (DOCX) is also an XML.

First I wrote my Query to get all the data I need and then I exported it to XML:
{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<tables>
  <table>
    <name>TABLE_A</name>
    <description>Some table description:
      - asdf
      - lorem ipsum
    </description>
    <fields>
      <field>
        <name>ALARMID</name>
        <description>Alarm ID</description>
        <type>Char</type>
        <length>11</length>
        <key>Ja</key>
        <peoplecode>Nein</peoplecode>
      </field>
      <field>
        <name>EFFDT</name>
        <description>Gültig ab</description>
        <type>Date</type>
        <length>10</length>
        <key>Ja</key>
        <peoplecode>Nein</peoplecode>
      </field>
    </fields>
  </table>
  <table>
    <name>TABLE_B</name>
    <description>description ....</description>
    <fields>
      <field>
        <name>ALARMID</name>
        <description>Alarm ID</description>
        <type>Char</type>
        <length>11</length>
        <key>Ja</key>
        <peoplecode>Nein</peoplecode>
      </field>
      <field>
        <name>EFFDT</name>
        <description>Gültig ab</description>
        <type>Date</type>
        <length>10</length>
        <key>Ja</key>
        <peoplecode>Nein</peoplecode>
      </field>
      <field>
        <name>GRUPPEID</name>
        <description>Gruppe ID</description>
        <type>Char</type>
        <length>11</length>
        <key>Ja</key>
        <peoplecode>Nein</peoplecode>
      </field>
    </fields>
  </table>
</tables>
{% endhighlight %}

### Create Word Template
Next, I created a Word Template which has the structure to describe one of my tables:
![Create Word Template](/media/062015-Generating-Word-Documents-With-XSLT-Shot1.png)

### Create XLS File
Now comes the tricky part. Based on the created word template I created the XSL File.
The DOCX-File is an archive from where you can extract the file 'word/document.xml'.
In this document.xml is the XML-Structure we have to create:

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document>
  <w:body>
    <w:p>
      <w:pPr>
        <w:pStyle w:val="Heading1" />
        <w:rPr>
          <w:lang w:val="de-CH" />
        </w:rPr>
      </w:pPr>
      <w:r>
        <w:rPr>
          <w:lang w:val="de-CH" />
        </w:rPr>
        <w:t>Tabellen</w:t>
      </w:r>
    </w:p>
    
    ....
    
  </w:body>
</w:document>
{% endhighlight %}

With this XML-Document I created an XSL-Template to generate the Word-Document:
{% highlight xml %}
<xsl:template match="/tables">
  <w:document>
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
      
      <!-- Use 'table'-Template for each table -->
      <xsl:for-each select="table">
        <xsl:apply-templates select="." />
      </xsl:for-each>
      
      <w:p>
        <w:bookmarkStart w:id="0" w:name="_GoBack" />
        <w:bookmarkEnd w:id="0" />
      </w:p>
      <w:sectPr w:rsidR="00352429" w:rsidRPr="00352429">
        <w:pgSz w:w="11906" w:h="16838" />
        <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"
          w:header="708" w:footer="708" w:gutter="0" />
        <w:cols w:space="708" />
        <w:docGrid w:linePitch="360" />
      </w:sectPr>
    </w:body>
  </w:document>
</xsl:template>
{% endhighlight %}

As you can see I created an own template to create the chapter for each table:
{% highlight xml %}
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
  
  ... 
  
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
      
      ...
    </w:tr>
    
    <!-- Create table rows for each field -->
    <xsl:for-each select="fields/field">
      <xsl:apply-templates select="." />
    </xsl:for-each>
    
  </w:tbl>
  <w:p/>
</xsl:template>
{% endhighlight %}

To generate the table with the fields I created a template for each table row:
{% highlight xml %}
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
    
    ...
    
  </w:tr>
</xsl:template>
{% endhighlight %}

As you can see above, I replaced my placeholders from the template with 'value-of'-Tag's to add the content to the document.
Example:
{% highlight xml %}
<xsl:value-of select="name" />
{% endhighlight %}

The whole XSL-File can be found here: [transform.xsl](/media/062015-Generating-Word-Documents-With-XSLT-Transform.xsl)

### Make the transformation

To make the transformation I wrote a small Java program.
I used the Library [XALAN](https://xalan.apache.org/):

{% highlight xml %}
<dependency>
    <groupId>xalan</groupId>
    <artifactId>xalan</artifactId>
    <version>2.7.2</version>
</dependency>
{% endhighlight %}

The XSLT transformation is done very easy with [XALAN](https://xalan.apache.org/).
Here a snippet of an easy transform() - Method:

{% highlight java %}
import java.io.FileOutputStream;
import java.io.IOException;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class XSLTTransformatorImpl implements XSLTTransformator {

   @Override
   public void transform(String inputFile, String outputFile, String xslFile) {
      TransformerFactory factory = TransformerFactory.newInstance();
      FileOutputStream outputStream = null;
      try {
         Transformer transformer = factory.newTransformer(new StreamSource(xslFile));
         outputStream = new FileOutputStream(outputFile);
         StreamResult outputTarget = new StreamResult(outputStream);
         transformer.transform(new StreamSource(inputFile), outputTarget);
      } catch (TransformerException e) {
         e.printStackTrace();
      } catch (IOException e) {
         e.printStackTrace();
      } finally {
         if (outputStream != null) {
            try {
               outputStream.close();
            } catch (IOException e) {
               e.printStackTrace();
            }
         }
      }
   }
}
{% endhighlight %}

### The transformed document
Finally I got my finished word document.
The Java program did it with the following steps:

 - Take Input-XML
 - Transform it with transform.xsl (see above) to document.xml
 - Pack the document.xml into the DOCX ([Zip4J](http://www.lingala.net/zip4j/))

Thats it. And the output was my required doc:

![Generated DOCX](/media/062015-Generating-Word-Documents-With-XSLT-Shot2.png)

If you somehow have to transform XML-Data respectively bring it to another format, XSLT is very powerful.
Get more information about XSLT [here](http://www.w3schools.com/xsl/).

---
layout:     post
title:      "Attributbasierte Autorisierung in einer Branchenlösung für das Versicherungswesen"
subtitle:   "Bachelor Thesis @ HSR"
date:       2017-10-23 17:00:00
author:     "Stefan Kapferer"
header-img: "img/102017-attributbasierte-autorisierung-versicherungswesen.jpg"
tags:       [abac, data-access-security]
---

## Einleitung
Meine Bachelorarbeit [Attributbasierte Autorisierung in einer Branchenlösung für das Versicherungswesen](https://eprints.hsr.ch/602/), welche ich zusammen mit Samuel Jost und dem Industriepartner [Adcubum AG](http://www.adcubum.com) erarbeitet habe, wurde in den letzten Tagen von der [HSR](http://www.hsr.ch) publiziert.
Das komplette Dokument ist unter folgendem Link zu finden: [https://eprints.hsr.ch/602/](https://eprints.hsr.ch/602/)


## Abstract
In adcubum SYRIUS®, einer geschichteten ERP-Lösung für Versicherungen, werden Berechtigungen direkt in der Datenbank verwaltet. Zugriffe auf die Daten aus SYRIUS werden in der Persistenzschicht autorisiert. Diese Lösung bringt Probleme mit sich, sobald Datenteilbestände in externen Komponenten, wie zum Beispiel einer Such- und Indexierungslösung, gehalten werden. Um diese Daten zu autorisieren, muss heute zusätzlich SYRIUS aufgerufen werden. Damit zukünftig Daten in einer externen Komponente autorisiert werden können, wurde in der Studienarbeit von Stefan Kapferer ein «Redesign» der Persistenzschicht vorgeschlagen und eine RESTful HTTP Schnittstelle für die neue Komponente entworfen. Die vorliegende Arbeit prüft, ob eine auf dem «Attribute-based Access Control» (ABAC)-Paradigma basierende Komponente die jetzige Berechtigungslösung ersetzen kann. 

In dieser Bachelorarbeit wurden die fachlichen Schutzanforderungen an die Autorisierungskomponente in Zusammenarbeit mit Kunden von Adcubum aufgenommen und in Form von User Stories erfasst. Anhand der Anforderungen wurde analysiert, welche Informationen das System für die Autorisierungsentscheidungen benötigt und aus welchen Datenquellen diese bezogen werden. Weiterhin wurde ein Performancekostendach für die Autorisierungsanfragen festgelegt und untersucht, an welchen Stellen der vorgeschlagenen Architektur Performanceoptimierungen möglich sind. Policies zu den wichtigsten funktionalen Anforderungen zeigen auf, dass die technische Umsetzung mit dem ABAC-Paradigma möglich ist. Für die Erstellung der Policies wurden verschiedene Policy-Syntaxen evaluiert, wobei die Entscheidung auf die verbreitete XML-Sprache XACML fiel. Der entwickelte Prototyp verwendet die in der vorangegangenen Studienarbeit definierte Schnittstelle, um Autorisierungsanfragen auf Basis der verfassten XACML-Policies zu verarbeiten. Weiter wurden Vorschläge für das Migrationsvorgehen und dessen Herausforderungen erarbeitet. 

Diese Arbeit liefert die konzeptionellen Grundlagen für die Entwicklung eines ABAC-basierten Autorisierungssystems. Die in dieser Arbeit erfassten funktionalen und nichtfunktionalen Anforderungen ermöglichen eine fundierte Evaluation eines Autorisierungsproduktes. Der Prototyp mit den verfassten XACML-Policies zeigt, dass sich die an SYRIUS gestellten Schutzanforderungen mit ABAC umsetzen lassen. Technische Risiken, welche der Architekturdesignwechsel hin zu ABAC mit sich bringt, konnten durch diese Arbeit minimiert werden.

## Report
Der ganze Bericht als PDF kann [hier](https://eprints.hsr.ch/602/1/FS%202017-BA-EP-Jost-Kapferer-Attributbasierte%20Autorisierung%20in%20einer%20Branchenl%c3%b6sung%20f%c3%bcr%20d.pdf) heruntergeladen werden.

## Acknowledgments
Ich bedanke mich bei Samuel Jost für die tolle Zusammenarbeit und bei Prof. Dr. O. Zimmermann für die hervorragende Betreuung der Arbeit. Ausserdem möchte ich mich bei allen Personen bei der [Adcubum AG](http://www.adcubum.com), welche uns bei dieser Arbeit unterstützt haben, herzlich bedanken. Die Erarbeitung dieser Bachelorarbeit war sehr spannend und hat auch viel Spass gemacht, vorallem weil sie uns Einblicke in verschiedenste Aufgabengebiete gegeben hat. Vom Requirements Engineering, über die Software-Architektur bis hin zur Implementation, hat diese Arbeit Skills in allen Disziplinen der Softwareentwicklung von uns abverlangt.


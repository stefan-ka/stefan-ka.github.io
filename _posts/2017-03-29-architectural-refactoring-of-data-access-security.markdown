---
layout:     post
title:      "Architectural Refactoring of Data Access Security"
subtitle:   "Semester Thesis @ HSR"
date:       2017-03-29 23:20:00
author:     "Stefan Kapferer"
header-img: "img/032017-architectural-refactoring-of-data-access-security.jpg"
tags:       [abac, data-access-security, architectural-refactoring, strategic-domain-driven-design]
---

## Introduction
My semester thesis [Architectural Refactoring of Data Access Security](https://eprints.hsr.ch/564/), which I made together with the industrial partner [Adcubum AG](http://www.adcubum.com), has been published by [HSR](http://www.hsr.ch) these days.
The document can be found here: [https://eprints.hsr.ch/564/](https://eprints.hsr.ch/564/)

Since it is written in German, I provide an abstract about my work in English here. 

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">My semester thesis has been published: <a href="https://t.co/eatHXyNluO">https://t.co/eatHXyNluO</a> Many thanks to the industry partner <a href="https://twitter.com/Adcubum">@Adcubum</a>, especially <a href="https://twitter.com/alexgfeller">@alexgfeller</a>.</p>&mdash; Stefan Kapferer (@stefankapferer) <a href="https://twitter.com/stefankapferer/status/847203298532872192">March 29, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## Abstract
In adcubum SYRIUS, which is a layered ERP-Solution for insurance, the access permissions are stored inside the database. The authorization of the data is performed with every data access inside the persistence layer. This solution is sufficient, as long as all data which need to be authorized are stored inside the local database.

Strategic Domain-Driven Design (DDD) is a method which can be used to identify modules or microservices. In this semester thesis a prototype was developed which built a separate Bounded Context for the authorization according to DDD. This Bounded Context is deployed as a separate microservice and can be used by the core domains via a remote interface. Therefore, a remote authorization interface based on RESTful HTTP was developed during this semester thesis. In addition, the persistence layer of adcubum SYRIUS was redesigned to extract the old authorization solution and use the new remote interface instead. Furthermore, the «Attribute-based Access Control» (ABAC) paradigm was analyzed to simplify the maintenance and configuration of the current RBAC-based solution. With a mock implementation of a new authorization system and its remote interface, the feasibility of the concept of an external authorization solution has been verified.

For the industrial partner Adcubum, this semester thesis determined where within SYRIUS the new remote authorization interface has to be called. Additionally, the RESTful HTTP interface documents which data must be transfered to the authorization system. Based on the considerations on how the data access control model should be changed from RBAC to ABAC, a template-conformable and reusable Architectural Refactoring was derived.

## Report
The whole report in German can be found [here](https://eprints.hsr.ch/564/1/HS16-SA-EP-Kapferer-ArchitecturalRefactoringDataAccessSecurity.pdf).

## Acknowledgments
I would like to thank my thesis advisor, Prof. Dr. O. Zimmermann, and the representatives of the industry partner [Adcubum AG](http://www.adcubum.com), for their support. It was a pleasure to work with such experienced software architects.


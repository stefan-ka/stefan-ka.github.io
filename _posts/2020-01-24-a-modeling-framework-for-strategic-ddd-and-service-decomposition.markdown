---
layout:     post
title:      "A Modeling Framework for Strategic Domain-driven Design and Service Decomposition"
date:       2020-01-24
summary:    With my master thesis at HSR I proposed a modeling framework for Strategic Domain-driven Design (DDD) and service decomposition that has been implemented by the Context Mapper open source project.
---

I recently finished my master thesis **[A Modeling Framework for Strategic Domain-driven Design (DDD) and Service Decomposition](https://eprints.hsr.ch/821/)** 
at [HSR](https://www.hsr.ch) which continues the work on the [Context Mapper](https://contextmapper.github.io) tool and describes the
modeling framework architecture that we implement in our open source project. 

The whole thesis is published by [HSR](https://www.hsr.ch) and can be found [here](https://eprints.hsr.ch/821/). 
Below you find the abstract of the paper.

## Problem
The decomposition of a system into modules or services is a challenging practical problem and research question that has 
not been answered satisfactorily yet. With the current trend towards microservices, Strategic Domain-driven Design (DDD) 
has become a popular technique to decompose a domain into so-called Bounded Contexts. In my previous work I presented 
[Context Mapper](https://contextmapper.org/), an open source tool offering a Domain-specific Language (DSL) based on the 
DDD patterns. 

![Context Mapper DSL (Eclipse Plugin Screenshot)](/media/012020-Eclipse-Screenshot.png)

It supports the evolution of DDD pattern-based architecture models in a formal and expressive way. By 
applying Architectural Refactorings (ARs), systems can be decomposed in an iterative manner. However, our validation 
activities have shown that our tool-based approach requires additional capabilities to expand the target user group. 
For instance, support for reverse engineering has been requested since re-modeling existing systems is often too 
expensive in brownfield projects. Decomposition on the basis of a systematic approach and generating graphical Context Maps 
are other user requirements.

## Result
With this thesis I propose a modular and extensible component architecture for a modeling framework based on Strategic 
DDD. The already existing [Context Mapper](https://contextmapper.org/) tool evolved into a framework offering components 
for reverse engineering, architecture modeling, refactoring, systematic decomposition, and generation of other 
representations from the Context Mapper DSL (CML) models. 

![Context Mapper Framework Overview](/media/012020-master-thesis-framework-overview.png)

The DSL constitutes the core component of the framework. With the discovery library I propose a strategy-based approach 
to reverse engineer CML models. An extended set of ARs has been conceptualized allowing users to evolve the architecture 
models iteratively. With Service Cutter, I integrated a systematic service decomposition approach to derive new Context 
Maps that improve coupling and cohesion. A graphical Context Map generator enhances the transformation tools to convert 
CML code into visual diagrams.

![Graphical Context Map Example](/media/012020-context-map-generator-example.png)

## Conclusion
The proposed framework supports architects and business analysts in creating DDD-based models and improve their 
productivity at the same time. I hypothesize that the mentioned personas can benefit from a tool which assists them
in evolving Context Maps. During this thesis I applied action research to validate the concepts and improve the 
prototype iteratively. With case studies such as the Lakeside Mutual microservice project and our own framework architecture 
I validated the usefulness and effectiveness of the suggested modeling framework. The conducted validation activities 
indicate that the hypothesis above holds true.

## Further Information & Links
 * My master thesis report: [https://eprints.hsr.ch/821/](https://eprints.hsr.ch/821/)
 * Context Mapper project: [https://contextmapper.org/](https://contextmapper.org/)
 * Our research papers: [https://contextmapper.org/background-and-publications/](https://contextmapper.org/background-and-publications/)

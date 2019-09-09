---
layout:     post
title:      "Service Decomposition as a Series of Architectural Refactorings"
date:       2019-09-05
summary:    This term project conducted at HSR presents Architectural Refactorings (ARs) derived from Decomposition Criteria (DC) compiled from literature and own experience. The selected ARs have been implemented as code refactorings for the Context Mapping DSL (CML) language in the Context Mapper tool.
---

I recently submitted my term project **[Service Decomposition as a Series of Architectural Refactorings](https://eprints.hsr.ch/784/)** at 
[HSR](https://www.hsr.ch) which continues the work on the [Context Mapper](https://contextmapper.github.io) tool. With the project 
we implemented seven Architectural Refactorings (ARs) as code refactorings for the Context Mapping DSL (CML) in the 
[Context Mapper](https://contextmapper.github.io) tool. An overview of all these refactorings can be found 
[here](https://contextmapper.github.io/docs/architectural-refactorings/) in the Context Mapper [documentation](https://contextmapper.github.io/docs). 
With the project we have further improved the syntax of CML and implemented a service contract generator. This 
[MDSL](https://socadk.github.io/MDSL/) (micro-)service contract generator shall provide support and advice how a DDD Context Map 
can be implemented in a (micro-)service architecture. The documentation for the [MDSL](https://socadk.github.io/MDSL/) generator 
can be found [here](https://contextmapper.github.io/docs/mdsl/). 

The whole project is published by [HSR](https://www.hsr.ch) and can be found [here](https://eprints.hsr.ch/784/). 
Below you find the abstract of the paper.

## Introduction
Decomposing a system into modules or services always has been a hard design problem. With the current trend towards microservices, 
this issue has become even more relevant and challenging. Domain-driven Design (DDD) with its Bounded Contexts provides one popular 
technique to decompose a domain into multiple parts. The open source tool [Context Mapper](https://contextmapper.github.io), 
developed in our previous term project, offers a Domain-specific Language (DSL) for the strategic DDD patterns. DSL and supporting 
tools assist architects in the process of finding service decompositions. [Context Mapper](https://contextmapper.github.io) has 
already been used in practice projects, which led to suggestions how to improve the DSL to further increase its usability. Moreover, 
[Context Mapper](https://contextmapper.github.io) at present does not offer any transformations or refactoring tools to improve and 
evolve the DDD models. Finally, our previous work only gives very basic advice on how to implement systems that have been modeled in 
[Context Mapper](https://contextmapper.github.io) in a (micro-)service-oriented architectural style.

## Result
This work presents a [series of Architectural Refactorings (ARs)](https://contextmapper.github.io/docs/architectural-refactorings/) 
for strategic DDD models based on corresponding Decoupling Criteria (DC) collected from literature and personal experience. 

![Architectural Refactorings (ARs derived from Decomposition Criteria (DC) compiled from literature and own experience)](/media/092019-ar-by-decoupling-criteria-mapping.png)

These refactorings allow a software architect to (de-)compose a domain iteratively. Aiming for a broad DC coverage, a set of seven 
ARs has been implemented. These ARs are realized as code refactorings for the Context Mapper DSL (CML) language and support splitting, 
extracting and merging Bounded Contexts and/or Aggregates. Therefore, DSL users are able to refactor their CML models within the 
provided Eclipse plugin. 

![The ARs have been implemented as Code Refactorings for the Context Mapper DSL (CML) and integrated into the Eclipse IDE.](/media/092019-eclipse-screenshot-abstract.png)

A new [service contract generator](https://contextmapper.github.io/docs/mdsl/) offers assistance how to implement the DDD models in 
an (micro-)service-oriented architecture. The resulting contracts are written in the 
[Microservices Domain Specific Language (MDSL)](https://socadk.github.io/MDSL/), another emerging DSL for specifying service contracts.

## Conclusion
The provided DSL with its seven ARs, implemented as model transformations, support evolving DDD-based models in an iterative way. 
The conducted validation activities support our hypothesis that software architects can benefit from such an approach and tool. 
Action research has been applied to improve Context Mapper in each iteration of the prototypical implementation. Basic case studies 
conducted on real world projects in the industry indicated the usefulness and effectiveness of the modeling language. More advanced 
validation activities still have to be conducted to analyze and demonstrate the practicability of the ARs.


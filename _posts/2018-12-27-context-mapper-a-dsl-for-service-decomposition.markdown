---
layout:     post
title:      "Context Mapper: A DSL for Service Decomposition"
date:       2018-12-27
summary:    A Domain-specific Language (DSL) for Service Decomposition based on the strategic Domain-Driven Design (DDD) patterns. A term project at HSR.
---

## Introduction
With my term project "**A Domain-specific Language for Service Decomposition**" I worked on an approach aiming to formalize an interpretation 
of the strategic DDD patterns and how they can be combined. The resulting [Context Mapper](https://contextmapper.github.io/) 
Domain-specific Language (DSL), provides a foundation for structured service decomposition approaches such as 
[Service Cutter](https://servicecutter.github.io/). The decomposition of applications into appropriately sized services towards 
Service-oriented a.k.a. Microservice architectures is challenging. The DSL allows to create DDD context maps and use them as input for 
the [Service Cutter](https://servicecutter.github.io/) tool. Other decomposition approaches using the DSL will follow with the next project.
You can further convert the context maps into [PlantUML](http://plantuml.com/) component and class diagrams. 
The full project report will be published by [HSR](http://hsr.ch/) soon (January 2019). However, if you are interested you can already check out 
the open source project [Context Mapper](https://contextmapper.github.io/) which is the result of the introduced term project.

## Strategic Domain-driven Design (DDD)
DDD provides an approach to decompose a domain into multiple bounded contexts. Thereby its patterns and especially the bounded contexts 
have gained more attention within the last years, due to the Microservice architectures trend. At the same time, there are different 
interpretations and a certain ambiguity regarding the original pattern definitions of [Evans](https://www.amazon.de/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215) 
and how they can be combined. Therefore, this project aims to provide a formal definition of such an interpretation. 
Note that it reflects my interpretation based on the DDD literature such as [Evans](https://www.amazon.de/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215), 
[Vernon](https://www.amazon.com/Implementing-Domain-Driven-Design-Vaughn-Vernon/dp/0321834577), 
[Brandolini](https://www.infoq.com/articles/ddd-contextmapping), personal experience and inputs of my project supervisor. 
I'm very interested in other opinions and I see the [Context Mapper](https://contextmapper.github.io) project as a work in progress which 
hopefully will be developed further by incorporating valuable feedback out of the DDD community.

The following domain model illustrates the structure on which the [Context Mapper](https://contextmapper.github.io) DSL is based on. 
The model's main object is the context map which contains multiple bounded contexts and their relationships. Each bounded context 
implements parts of given subdomains.

[![Context Mapper Semantic Model](/media/122018-Strategic_DDD_Domain_Model.png)](/media/122018-Strategic_DDD_Domain_Model.png)

Regarding the relationship patterns, we differentiate between _symmetric_ and _asymmetric_ (Upstream/Downstream) relationships. 
With _asymmetric_ relationships all relationships with an Upstream and a Downstream are meant. The _symmetric_ relationships, namely 
Partnership and Shared Kernel, describe intimate relationships where no Upstream and/or Downstream can be clearly defined. 
In other words, in these relationships both bounded contexts depend on the other one. _Asymmetric_ relationships in contrast have the 
characteristic that only one of the two contexts depends on the other. As [Evans](https://www.amazon.de/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215) 
and [Vernon](https://www.amazon.com/Implementing-Domain-Driven-Design-Vaughn-Vernon/dp/0321834577), I use the terms _Upstream_ and 
_Downstream_. The _Downstream_ context is the one who depends on the _Upstream_ context, whereas the _Upstream_ context is not dependent 
on the _Downstream_ context.

The Customer/Supplier pattern describes, according to my interpretation, a special case of an Upstream/Downstream relationship where the 
_Upstream_ is the _Supplier_ and the _Downstream_ the _Customer_. The model above tries to differentiate the two cases by using the
term _Generic Upstream/Downstream Relationship_ for Upstream/Downstream relationships which are not Customer/Supplier relationships. 
However, an upstream or downstream bounded context can implement certain relationship patterns, or _Relationship Role's_ as I call them. 
The patterns which can be implemented by an upstream bounded context are Published Language (PL) and Open Host Service (OHS). 
The corresponding downstream roles are Anticorruption Layer (ACL) and Conformist.

### Possible Combinations
There are different opinions on how these strategic DDD patters can be combined. This approach and the implemented 
[Context Mapper](https://contextmapper.github.io) reflects my interpretation based on the DDD literature. The meta-model above 
already implies certain rules regarding applicability. 

First, the patterns PL, OHS, ACL and Conformist are only applicable in Upstream/Downstream relationships. In a Shared Kernel relationship 
the bounded contexts are sharing common code, typically a library, which is used for their communication. Both bounded contexts depend on 
that code and the teams manage it together. The application of one of the four mentioned patterns is contradictory within such a situation. 
The same applies to the Partnership pattern, since it clearly states that both bounded contexts depend on each other. Both contexts "fail 
or succeed together". This means that if one of the bounded contexts fails, the other automatically fails as well. An application of the 
four patterns PL, OHS, ACL and Conformist is somehow contradictory again, since there can not be an upstream or downstream in such a 
relationship. The application of one of the patterns would require to declare one of the contexts upstream and the other downstream. And, 
as already mentioned, an upstream never depends on a downstream or "fails" if one of the downstreams does.

Further, the model implies that the patterns PL and OHS are only applicable on upstream bounded contexts, and the patterns ACL and 
Conformist only on downstream contexts. This seems to be obvious in my opinion. However, whereas on an upstream context both patterns PL 
and OHS can be applied together, only one of the patterns ACL and Conformist can be applied on a downstream context. The two downstream 
roles describe two different solutions a team can apply in case they are the downstream in a Upstream/Downstream relationship where the 
upstream does not really care about the needs of the downstreams. The downstream can either decide to "conform" to the upstream or to 
implement an ACL, but both patterns at the same time does not seem to make much sense.

The special case of a Customer/Supplier relationship probably raises the most questions regarding combinations with the other relationship 
patterns. In my opinion, the combination with the OHS pattern leads to contradictions and it is therefore not allowed within the 
[Context Mapper](https://contextmapper.github.io) DSL. Whereas the Customer/Supplier pattern says that the supplier has to prioritize 
his implementation tasks according to the wishes of the customer, the OHS pattern somehow implies that the upstream implements "one 
solution for all" downstreams. This would mean that the supplier has to consolidate all the wishes of many different customers into one 
single API, which is not a very likely scenario from my experience. At some point a customer will have some special requirements which are 
not needed by the other customers and an implementation within the same public API would pollute the API which should be kept clean. In 
this situation the upstream team may implement another specialized API for that customer and that special purpose. However, in this case 
the relationship between this downstream/customer and the upstream/supplier implementing the OHS is no longer clearly defined by the 
communication over the OHS and it would be misleading to declare it this way.

Another contradictory combination according to my interpretation is Customer/Supplier with Conformist. The customer within a 
Customer/Supplier relationship should not be in the situation where it has to "conform" to the supplier, since the supplier should implement 
the common model according to the customers requirements. For the same reason I tend to argue that the combination ACL and 
Customer/Supplier is contradictory. However, I allowed this combination in [Context Mapper](https://contextmapper.github.io/), since it is 
also possible to argue that an ACL can make sence in any case. At the same time I would say that this ACL should not need a defensive 
character in a Customer/Supplier relationship and might be better called a "translation layer".

## A Domain-specific Language (DSL) as a formal approach for DDD
The [Context Mapper](https://contextmapper.github.io/) DSL provides a tool to create context maps according to the meta-model introduced 
above in a formal manner. In the [examples repository](https://github.com/ContextMapper/context-mapper-examples) you can find two examples 
for such context maps. The first is based on a fictitious insurance company and the second on the 
[DDD Sample Application](https://github.com/citerus/dddsample-core).

The following illustration shows the context map of the insurance scenario inspired by the representation of 
[Vernon](https://www.amazon.com/Implementing-Domain-Driven-Design-Vaughn-Vernon/dp/0321834577) and 
[Brandolini](https://www.infoq.com/articles/ddd-contextmapping). The complete example and short descriptions of the bounded contexts 
can be found [here](https://github.com/ContextMapper/context-mapper-examples/tree/master/src/main/resources/insurance-example).

![Insurance Scenario Context Map](/media/122018-ContextMap-Illustration.png)

This context map can be described in the [Context Mapper](https://contextmapper.github.io/) language (CML) as follows:

<div class="highlight"><pre><span></span><span class="c">/* Example Context Map written with &#39;ContextMapper DSL&#39; */</span>
<span class="k">ContextMap</span> {
  <span class="k">type</span> = <span class="k">SYSTEM_LANDSCAPE</span>
  <span class="k">state</span> = <span class="k">TO_BE</span>

  <span class="c">/* Add bounded contexts to this context map: */</span>
  <span class="k">contains</span> CustomerManagementContext
  <span class="k">contains</span> CustomerSelfServiceContext
  <span class="k">contains</span> PrintingContext
  <span class="k">contains</span> PolicyManagementContext
  <span class="k">contains</span> RiskManagementContext
  <span class="k">contains</span> DebtCollection

  <span class="c">/* Define the contexts relationships */</span>
  CustomerSelfServiceContext -&gt; CustomerManagementContext : <span class="k">Customer-Supplier</span>

  CustomerManagementContext -&gt; PrintingContext : <span class="k">Upstream-Downstream</span> {
    <span class="k">implementationTechnology</span> = <span class="s">&quot;SOAP&quot;</span>
    <span class="k">upstream</span> <span class="k">implements</span> <span class="k">OPEN_HOST_SERVICE</span>, <span class="k">PUBLISHED_LANGUAGE</span>
    <span class="k">downstream</span> <span class="k">implements</span> <span class="k">ANTICORRUPTION_LAYER</span>
  }

  PrintingContext &lt;- PolicyManagementContext : <span class="k">Upstream-Downstream</span> {
    <span class="k">implementationTechnology</span> = <span class="s">&quot;SOAP&quot;</span>
    <span class="k">upstream</span> <span class="k">implements</span> <span class="k">OPEN_HOST_SERVICE</span>, <span class="k">PUBLISHED_LANGUAGE</span>
    <span class="k">downstream</span> <span class="k">implements</span> <span class="k">ANTICORRUPTION_LAYER</span>
  }

  RiskManagementContext &lt;-&gt; PolicyManagementContext : <span class="k">Partnership</span> {
    <span class="k">implementationTechnology</span> = <span class="s">&quot;RabbitMQ&quot;</span>
  }

  PolicyManagementContext -&gt; CustomerManagementContext : <span class="k">Upstream-Downstream</span> {
    <span class="k">implementationTechnology</span> = <span class="s">&quot;RESTful HTTP&quot;</span>
    <span class="k">upstream</span> <span class="k">implements</span> <span class="k">OPEN_HOST_SERVICE</span>, <span class="k">PUBLISHED_LANGUAGE</span>
    <span class="k">downstream</span> <span class="k">implements</span> <span class="k">CONFORMIST</span>
  }

  DebtCollection -&gt; PrintingContext : <span class="k">Upstream-Downstream</span> {
    <span class="k">implementationTechnology</span> = <span class="s">&quot;SOAP&quot;</span>
    <span class="k">upstream</span> <span class="k">implements</span> <span class="k">OPEN_HOST_SERVICE</span>, <span class="k">PUBLISHED_LANGUAGE</span>
    <span class="k">downstream</span> <span class="k">implements</span> <span class="k">ANTICORRUPTION_LAYER</span>
  }

  PolicyManagementContext &lt;-&gt; DebtCollection : <span class="k">Shared-Kernel</span> {
    <span class="k">implementationTechnology</span> = <span class="s">&quot;Shared Java Library, Communication over RESTful HTTP&quot;</span>
  }

}
</pre></div>

The asymmetric relationships are declared with the _<->_ arrows in both directions, whereas the Upstream/Downstream relationships are 
declared with an arrow (_<-_ or _->_) pointing from the downstream towards the upstream (illustrating the dependency). Check 
our [Language Reference](https://contextmapper.github.io/docs/language-reference/) for more details about the language. Further note 
that the example above does not contain the bounded context specifications. The complete CML code of the example can be found 
[here](https://github.com/ContextMapper/context-mapper-examples/blob/master/src/main/resources/insurance-example/Insurance-Example_Context-Map.cml). 
With the integration of the [Sculptor DSL](http://sculptorgenerator.org/), CML allows to specify the bounded contexts in terms of the 
tactic DDD patterns.

## Service Decomposition
A model written in the [Context Mapper](https://contextmapper.github.io/) DSL can be used as input for 
[Service Cutter](https://servicecutter.github.io/) in order to improve the boundaries of the bounded contexts in terms of [Service Cutter](https://servicecutter.github.io/)'s 
coupling criteria. The following illustration shows the [Service Cutter](https://servicecutter.github.io/) result for the insurance example
introduced above.

![Service Cutter Result for the Insurance Example](/media/122018-service-cutter-result-insurance-leung.png)

The result perfectly represents the modeled bounded contexts and thus confirms a good coupling between the bounded contexts.

 * Service A: Printing Context
 * Service B: Risk Management Context
 * Service C: Policy Management Context
 * Service D: Debt Collection Context
 * Service E: Customer Management Context
 * Service F: Customer Self-Service Context
 
You can generate the [Service Cutter](https://servicecutter.github.io/) input files using [Context Mapper](https://contextmapper.github.io/)'s 
Eclipse plugin, which you find [here](https://contextmapper.github.io/docs/home/).

## Generating Graphical Representations
A DSL offers the possibility the transform your model into any other representation. Besides the transformation into [Service Cutter](https://servicecutter.github.io/) 
input files, [Context Mapper](https://contextmapper.github.io/) currently allows to generate [PlantUML](http://plantuml.com/) diagrams
as graphical representation of your context map. The generator creates a UML component diagram, illustrating the bounded contexts as 
components. It further creates corresponding interfaces and connections between the components according to the bounded context relationships.

The following image shows the generated component diagram for the insurance example:

![Generated PlantUML Component Diagram for the Insurance Example](/media/122018-plantuml-component-diagram-insurance-example.png)

The generator further creates a UML class diagram for every bounded context. [This page](https://contextmapper.github.io/docs/plant-uml/) 
describes how you can generate the UML diagrams out of context maps written in [Context Mapper](https://contextmapper.github.io/) DSL.

## Future Work
In the next term project, starting in February 2019, our goal is to work on other service decomposition approaches using the presented DSL.
By applying [architectural refactorings](https://link.springer.com/article/10.1007/s00607-016-0520-y) a context map written in the 
[Context Mapper](https://contextmapper.github.io/) DSL could be decomposed by splitting and merging bounded contexts stepwise. Other structured
decomposition approaches such as [Service Cutter](https://servicecutter.github.io/) using other algorithms and heuristics could be applied
as well.

Other future projects implementing other generators would be conceivable. Such transformations could provide the possibility to generate
other graphical representations or code. A code generator which creates microservice stubs (project templates) for the modeled bounded contexts
might be an interesting feature.

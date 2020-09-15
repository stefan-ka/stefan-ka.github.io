---
layout:     post
title:      "SummerSoC 2020: Domain-driven Service Design"
date:       2020-09-14
summary:    "SummerSoC 2020 paper presentation: Context Modeling, Model Refactoring and Contract Generation - this blogpost documents my examples and continues the demonstration at SummerSoC 2020 towards contract generation."
redirect_from:
  - /summersoc2020
  - /summersoc2020/
  - /SummerSoC2020
  - /SummerSoC2020/
---

![SummerSoC Logo](/media/summersoc_logo.png)

At [SummerSoC](https://www.summersoc.eu/) 2020 I present(ed) my ([Stefan Kapferer](https://stefan.kapferer.ch/about/)) and [Olaf Zimmermann](https://ozimmer.ch/)'s paper on «Domain-driven Service Design» (accepted; to be published soon) 

You can [download the slides](/media/Stefan-Kapferer-presentation-summersoc-2020.pdf) here.

The paper covers the following topics:

 * Service decomposition with **Strategic Domain-driven Design (DDD)**
 * **[Context Mapper](https://contextmapper.org/) DSL (CML)** as a _machine-readable_ approach to DDD Context Mapping
 * **Decomposition criteria**: How to decompose a domain and identify «Bounded Contexts»?
 * **Architectural Refactorings (ARs)** as model transformation for CML
 * An _incremental_ method to **decompose domains «step by step»**
 * **Service contract generation** out of the DDD models (with the [MDSL](https://microservice-api-patterns.github.io/MDSL-Specification/) language)

Since its not possible to cover all the topics in a 20 minutes presentation, I focus(ed) on _Strategic DDD_, the _[Context Mapper](https://contextmapper.org/) DSL (CML)_, and the _incremental decomposition method with Architectural Refactorings (ARs)_. In this blogpost I provide CML code for the examples I use(d) and continue the process towards _service contract generation_ with the [Microservice Domain-specific Language (MDSL)](https://microservice-api-patterns.github.io/MDSL-Specification/) (developed by [Olaf Zimmermann](https://ozimmer.ch/)).

## Content Outline

 1. [Strategic Domain-driven Design and Context Mapper](#strategic-domain-driven-design-and-context-mapper)
 2. [Decomposition Criteria](#decomposition-criteria)
 3. [Architectural Refactorings (ARs) as Model Transformations](#architectural-refactorings-ars-as-model-transformations)
 4. [Incremental Service Decomposition](#incremental-service-decomposition)
 5. [Service Contract Generation](#service-contract-generation)
 6. [Wrap Up](#wrap-up)

## Strategic Domain-driven Design and Context Mapper
The question how to decompose a software system into modules and/or services has gained much attention with the recent Microservice trend. The question is however not new. Parnas already wrote a paper «[On the criteria to be used in decomposing systems into modules](https://doi.org/10.1145/361598.361623)» in 1972.

One popular answer these days is Strategic Domain-driven Design (DDD). It emphasizes the need for a distinctive vocabulary, the ubiquitous language, in the domain model and suggests to decompose a domain into so-called «Bounded Contexts». A domain typically consists of multiple subdomains. In our presentation example: the _insurance domain_ consists of subdomains such as _customers_, _policies_, _risks_, etc.

![DDD Subdomains - a fictitious insurance scenario](/media/092020-Fictitious-Insurance-Example-Domain-Overview.png)

When implementing such a system with a service-oriented architectural style, microservices, or a modular monolith («modulith»), you are confronted with the question how many (micro-)services or modules the system shall exhibit. DDD practitioners suggest to identify Bounded Contexts and implement one subsystem (service or module) per context. A Bounded Context establishes a boundary within which a particular model is valid. 

The concepts and domain objects inside a Bounded Context shall be defined clearly and distinctively (the ubiquitous language). As the following example illustrates, a Bounded Context can implement parts of one or multiple subdomains:

![DDD Bounded Contexts implement multiple subdomains](/media/092020-Fictitious-Insurance-Example-Domain-Overview-2-three-services.png)

When we decompose our domain into multiple Bounded Contexts the question how this contexts integrate with each other raises naturally. This is where DDD Context Maps and _[context mapping](https://www.infoq.com/articles/ddd-contextmapping/)_ come into play. A Context Map illustrates the relationships between Bounded Contexts and how the data between them flow. The following Context Map shows one example for our fictitious insurance scenario:

![Example Context Map](/media/092020-insurance-context-map.png)

The «U» and «D» at some of the relations mean «upstream» and «downstream». The data in «Upstream-Downstream» relationships always flow from the upstream to the downstream. That means: the upstream exposes a part of its domain model (for example via a public API) to the downstream. The downstream context can either conform to the upstreams model (_CONFORMIST_), or implement an _Anticorruption Layer (ACL)_ to protect its own model from upstream changes. Upstream patterns are _Open Host Service (OHS)_ and _Published Language (PL)_. The OHS pattern is applied if the upstream context implements a public and open API that is supposed to be used by multiple downstream context in a unified manner. The published language (PL) is the part of the domain model that is exposed by the upstream - which is why this pattern is often used in combination with OHS.
If a relationship is marked with «Customer/Supplier», the two teams work closely together in a sense that the upstream team prioritizes its work according to the downstream (customer) requirements.
In symmetric relationships (_Partnership_ and _Shared Kernel_) there exist interdependecies which lead to a stronger coupling in comparison to Upstream-Downstream relationships. For more details about the DDD patterns, we recommend the following books and resources:

 * Evans, E.: _[Domain-Driven Design: Tackling Complexity in the Heart of Software](https://dddcommunity.org/book/evans_2003/)_, Addison-Wesley (2003)
 * Evans, E.: _[Domain-Driven Design Reference](https://domainlanguage.com/ddd/reference/)_
 * Vernon, V.: _[Implementing Domain-Driven Design](https://dddcommunity.org/book/implementing-domain-driven-design-by-vaughn-vernon/)_, Addison-Wesley (2013)
 * [More DDD resources](https://www.ifs.hsr.ch/index.php?id=15666&L=4de%2Fshops%2F2164%2F004)

[Context Mapper](https://contextmapper.org/) offers a Domain-specific Language (DSL) to model DDD Context Maps and Bounded Contexts in a _machine-readable_ manner. DDD practitioners have drawn Context Maps manually on paper so far. One of our goals with [Context Mapper](https://contextmapper.org/) was to reduce ambiguities regarding strategic DDD patterns and provide a [clear and precise interpretation](https://contextmapper.org/docs/language-model/) of how the patterns can be combined. We further believe that DDD Context Maps are artifacts that must evolve iteratively. The DSL approach comes with a few benefits:

 * Precise definition of what can be combined (semantic language rules/validators)
 * Models can be processed and transformed
   * Allows the implementation of model transformations/refactorings
 * Possibility to generate other representations of the model
   * Currently:
     * PlantUML component and class diagrams
     * Graphical Context Maps (as shown above)
     * Service contracts ([MDSL](https://microservice-api-patterns.github.io/MDSL-Specification/))
     * Microservice code (via [JHipster](https://www.jhipster.tech/))

The fictitious insurance example Context Map (as illustrated above) can be written in Context Mapper DSL (CML) as follows:

<div class="highlight"><pre><span></span><span class="k">ContextMap</span> InsuranceContextMap {
  <span class="c">/* Add bounded contexts to this context map: */</span>
  <span class="k">contains</span> CustomerManagementContext, CustomerSelfServiceContext, PrintingContext
  <span class="k">contains</span> PolicyManagementContext, RiskManagementContext, DebtCollection
  
  <span class="c">/* Define the context relationships: */</span> 
  CustomerSelfServiceContext [<span class="k">D</span>,<span class="k">C</span>]&lt;-[<span class="k">U</span>,<span class="k">S</span>] CustomerManagementContext
  
  CustomerManagementContext [<span class="k">D</span>,<span class="k">ACL</span>]&lt;-[<span class="k">U</span>,<span class="k">OHS</span>,<span class="k">PL</span>] PrintingContext
  
  PrintingContext [<span class="k">U</span>,<span class="k">OHS</span>,<span class="k">PL</span>]-&gt;[<span class="k">D</span>,<span class="k">ACL</span>] PolicyManagementContext
  
  RiskManagementContext [<span class="k">P</span>]&lt;-&gt;[<span class="k">P</span>] PolicyManagementContext

  PolicyManagementContext [<span class="k">D</span>,<span class="k">CF</span>]&lt;-[<span class="k">U</span>,<span class="k">OHS</span>,<span class="k">PL</span>] CustomerManagementContext

  DebtCollection [<span class="k">D</span>,<span class="k">ACL</span>]&lt;-[<span class="k">U</span>,<span class="k">OHS</span>,<span class="k">PL</span>] PrintingContext

  PolicyManagementContext [<span class="k">SK</span>]&lt;-&gt;[<span class="k">SK</span>] DebtCollection  
}

<span class="c">/* Bounded Context definitions */</span>
<span class="k">BoundedContext</span> CustomerManagementContext <span class="k">implements</span> CustomerManagementDomain {
    <span class="c">/* can contain domain model based on tactic DDD patterns */</span>
}

<span class="k">BoundedContext</span> CustomerSelfServiceContext <span class="k">implements</span> CustomerManagementDomain

<span class="k">BoundedContext</span> PrintingContext <span class="k">implements</span> PrintingDomain

<span class="k">BoundedContext</span> PolicyManagementContext <span class="k">implements</span> PolicyManagementDomain

<span class="k">BoundedContext</span> RiskManagementContext <span class="k">implements</span> RiskManagementDomain

<span class="k">BoundedContext</span> DebtCollection <span class="k">implements</span> DebtsDomain

<span class="c">/* domain &amp; subdomain definitions removed to save space */</span>
</pre></div>

_Note:_ Context Mapper not only supports modeling Bounded Contexts, you can also model your domain with its subdomains and specify which Bounded Contexts implement which subdomains. In addition, you can start your modeling process by declaring use cases or user stories and derive your subdomains and Bounded Contexts automatically. I don't explain this process here, as my colleague Olaf Zimmermann already covers this in [his blogpost](https://ozimmer.ch/practices/2020/06/10/ICWEKeynoteAndDemo.html) featuring our [rapid prototyping transformations](https://contextmapper.org/docs/rapid-ooad/).

For more information and starting points for [Context Mapper](https://contextmapper.org/) I recommend the following links:

 * [Installation, framework architecture, and getting started](https://contextmapper.org/docs/home/)
 * [Context Mapper DSL (CML) language reference](https://contextmapper.org/docs/language-reference/)
 * [Rapid prototyping: from user stories (or use cases) over subdomains (analysis) to Bounded Contexts (design)](https://contextmapper.org/docs/rapid-ooad/)
 * [Architectural Refactorings (ARs)](https://contextmapper.org/docs/architectural-refactorings/)
 * [Generators](https://contextmapper.org/docs/generators/)

## Decomposition Criteria
We have now seen how we can model DDD Context Maps and therefore describe system architectures in terms of Bounded Contexts. But this does still not really answer the question how we can identify Bounded Contexts. Which criteria and heuristics can we use to do that?

We [distilled a set of «Decomposition Criteria» (DCs)](https://eprints.hsr.ch/784/) empirically. We used research papers (such as the one of D.L. Parnas «On the Criteria To Be Used in Decomposing Systems into Modules»), resources of DDD experts (books, blogposts, conference talks), and our own experience in software projects. Here just a few of often mentioned decomposition criteria:

 * Use Cases
 * Ownership and teams (Conway's law)
 * Language and domain expert boundaries
 * Business process steps
 * Business capabilities
 * Data flow
 * Non-functional requirements (NFRs) such as security, availability, etc.

These are all criteria that can be reasons to split a Bounded Context or extract parts of a domain model into a separate Bounded Context. The [InfoQ article on Context Mapping by Alberto Brandolini](https://www.infoq.com/articles/ddd-contextmapping/) illustrates how such criteria can be used to identify Bounded Contexts and decompose an initial domain «step by step».

## Architectural Refactorings (ARs) as Model Transformations
One of the advantages of having a machine-readable Context Map: we can [implement model refactorings for our DSL](https://eprints.hsr.ch/819/). Thus, we can implement refactorings that allow users to decompose the described domain with tool-support.

Based on the decomposition criteria mentioned above we proposed a set of «Architectural Refactorings (ARs)»:

![Architectural Refactorings (ARs) Overview](/media/092020-ar-overview.png)

One example: «Split Bounded Context by Owner (AR-3)» ensures that only one team works on one Bounded Context. It can be applied if multiple teams work on the same context. The result of the refactoring: one Bounded Context per team. This increases team autonomy and establishes clear responsibilities.

We implemented this ARs as model transformations/refactorings for the CML language. You find an overview over all implemented ARs [here](https://contextmapper.org/docs/architectural-refactorings/). In the following I illustrate the application of «Split Bounded Context by Owner (AR-3)» on a CML model (as in my SummerSoC presentation).

Assume we have the following Bounded Context in our CML model (I still use the fictitious insurance scenario):

<div class="highlight"><pre><span></span><span class="c">/* Bounded Context Definitions */</span>
<span class="k">BoundedContext</span> CustomerManagementContext {
  <span class="k">type</span> = <span class="k">FEATURE</span>
  <span class="k">domainVisionStatement</span> = <span class="s">&quot;The customer management context is responsible for managing all the data of the insurance companies customers.&quot;</span>
  <span class="k">implementationTechnology</span> = <span class="s">&quot;Java, JEE Application&quot;</span>
  <span class="k">responsibilities</span> = <span class="s">&quot;Customers, Addresses&quot;</span>

  <span class="k">Aggregate</span> CustomersMainAggregate {
    <span class="k">owner</span> CustomerBackendTeam
    
    <span class="k">Entity</span> Customer { 
      <span class="k">aggregateRoot</span>
      
      - <span class="k">SocialInsuranceNumber</span> sin
      <span class="k">String</span> firstname
      <span class="k">String</span> lastname
      - <span class="k">List</span>&lt;Address&gt; addresses
    }
    
    <span class="k">Entity</span> Address {
      <span class="k">String</span> street
      <span class="k">int</span> postalCode
      <span class="k">String</span> city
    }
    
    <span class="k">ValueObject</span> SocialInsuranceNumber {
      <span class="k">String</span> sin <span class="k">key</span>
    }
  }

  <span class="k">Aggregate</span> CustomerSelfServiceAggregate {
        <span class="k">owner</span> CustomerFrontendTeam

        <span class="k">Entity</span> UserAccount {      
      <span class="k">String</span> username
      - <span class="k">Customer</span> accountCustomer
    }
    <span class="k">Entity</span> CustomerAddressChanged {
      <span class="k">aggregateRoot</span>
      
      - <span class="k">UserAccount</span> issuer
      - <span class="k">Address</span> changedAddress
    }
  }
    
}

<span class="c">/* Team&#39;s: */</span>
<span class="k">BoundedContext</span> CustomerFrontendTeam { <span class="k">type</span> <span class="k">TEAM</span> }
<span class="k">BoundedContext</span> CustomerBackendTeam { <span class="k">type</span> <span class="k">TEAM</span> }
</pre></div>

The given Bounded Context contains two Aggregates. With the _owner_ keyword, CML allows to assign the team that owns a given Aggregate. A team is a Bounded Context as well (in CML modeled with `type TEAM`). This describes a situation where teams and system or feature Bounded Contexts are not aligned. Multiple teams work on the same Bounded Context. In the [Context Mapper IDE (VS Code extension, Eclipse Plugin, or online)](https://contextmapper.org/docs/ide/) we can not apply «Split Bounded Context by Owner» on this context:

![Application of Architectural Refactoring in Visual Studio Code (Screenshot)](/media/092020-ar-3-vscode-screenshot.png)

For the model given above the refactoring will produce the following output:

<div class="highlight"><pre><span></span><span class="c">/* Bounded Context Definitions */</span>
<span class="k">BoundedContext</span> CustomerManagementContext {
  <span class="k">domainVisionStatement</span> = <span class="s">&quot;The customer management context is responsible for managing all the data of the insurance companies customers.&quot;</span>
  <span class="k">type</span> <span class="k">FEATURE</span>
  <span class="k">responsibilities</span> <span class="s">&quot;Customers, Addresses&quot;</span>
  <span class="k">implementationTechnology</span> <span class="s">&quot;Java, JEE Application&quot;</span>
  
  <span class="k">Aggregate</span> CustomerSelfServiceAggregate {
    <span class="k">owner</span> CustomerFrontendTeam
    <span class="k">Entity</span> UserAccount {
      <span class="k">String</span> username
      - <span class="k">Customer</span> accountCustomer
    }
    <span class="k">Entity</span> CustomerAddressChanged {
      <span class="k">aggregateRoot</span>
      - <span class="k">UserAccount</span> issuer
      - <span class="k">Address</span> changedAddress
    }
  }
}

<span class="k">BoundedContext</span> NewBoundedContext1 {
  <span class="k">Aggregate</span> CustomersMainAggregate {
    <span class="k">owner</span> CustomerBackendTeam
    <span class="k">Entity</span> Customer {
      <span class="k">aggregateRoot</span>
      - <span class="k">SocialInsuranceNumber</span> sin
      <span class="k">String</span> firstname
      <span class="k">String</span> lastname
      - <span class="k">List</span>&lt;Address&gt; addresses
    }
    <span class="k">Entity</span> Address {
      <span class="k">String</span> street
      <span class="k">int</span> postalCode
      <span class="k">String</span> city
    }
    <span class="k">ValueObject</span> SocialInsuranceNumber {
      <span class="k">String</span> sin <span class="k">key</span>
    }
  }
}

<span class="c">/* Team&#39;s: */</span>
<span class="k">BoundedContext</span> CustomerFrontendTeam {
  <span class="k">type</span> <span class="k">TEAM</span>
}

<span class="k">BoundedContext</span> CustomerBackendTeam {
  <span class="k">type</span> <span class="k">TEAM</span>
}
</pre></div>

As you can see, the resulting model contains one Bounded Context per team. By using the «Rename» refactoring we can improve the naming of the given Bounded Contexts: (we also post-processed the Bounded Context attributes a bit)

<div class="highlight"><pre><span></span><span class="c">/* Bounded Context Definitions */</span>
<span class="k">BoundedContext</span> CustomerSelfServiceContext {
  <span class="k">domainVisionStatement</span> = <span class="s">&quot;The customer self-service context provides a web application where customers can change their address.&quot;</span>
  <span class="k">type</span> <span class="k">FEATURE</span>
  <span class="k">responsibilities</span> <span class="s">&quot;Handle address change requests of customers&quot;</span>
  <span class="k">implementationTechnology</span> <span class="s">&quot;React Web Application&quot;</span>
  
  <span class="k">Aggregate</span> CustomerSelfServiceAggregate {
    <span class="k">owner</span> CustomerFrontendTeam
    <span class="k">Entity</span> UserAccount {
      <span class="k">String</span> username
      - <span class="k">Customer</span> accountCustomer
    }
    <span class="k">Entity</span> CustomerAddressChanged {
      <span class="k">aggregateRoot</span>
      - <span class="k">UserAccount</span> issuer
      - <span class="k">Address</span> changedAddress
    }
  }
}

<span class="k">BoundedContext</span> CustomerManagementContext {
  <span class="k">domainVisionStatement</span> = <span class="s">&quot;The customer management context is responsible for managing all the data of the insurance companies customers.&quot;</span>
  <span class="k">type</span> <span class="k">FEATURE</span>
  <span class="k">responsibilities</span> <span class="s">&quot;Customers, Addresses&quot;</span>
  <span class="k">implementationTechnology</span> <span class="s">&quot;Java, JEE Application&quot;</span>

  <span class="k">Aggregate</span> CustomersMainAggregate {
    <span class="k">owner</span> CustomerBackendTeam
    <span class="k">Entity</span> Customer {
      <span class="k">aggregateRoot</span>
      - <span class="k">SocialInsuranceNumber</span> sin
      <span class="k">String</span> firstname
      <span class="k">String</span> lastname
      - <span class="k">List</span>&lt;Address&gt; addresses
    }
    <span class="k">Entity</span> Address {
      <span class="k">String</span> street
      <span class="k">int</span> postalCode
      <span class="k">String</span> city
    }
    <span class="k">ValueObject</span> SocialInsuranceNumber {
      <span class="k">String</span> sin <span class="k">key</span>
    }
  }
}

<span class="c">/* Team&#39;s: */</span>
<span class="k">BoundedContext</span> CustomerFrontendTeam {
  <span class="k">type</span> <span class="k">TEAM</span>
}

<span class="k">BoundedContext</span> CustomerBackendTeam {
  <span class="k">type</span> <span class="k">TEAM</span>
}
</pre></div>

_Note:_ The refactorings also ensure that Context Map relationships (if you have any) stay consistent and are corrected if necessary (not shown above in order to keep the example shorter/simpler).

## Incremental Service Decomposition
In the refactoring example above we have shown one single decomposition step. We believe that decomposing a software system or domain into a Context Map (multiple Bounded Contexts) is an iterative and evolutionary process. By providing multiple ARs that are based on different decomposition criteria, one can decompose a domain with Context Mapper «step by step». The following graphic illustrates this idea:

![Incremental Decomposition Process](/media/092020-ar-incremental-application-and-method-embedding.png)

Users can start with the domain analysis and model their domain as one single context first. By applying the ARs on the strategic DDD level (see image above), users can decompose the domain «step by step» and evolve a Context Map iteratively. We also offer refactorings on the tactic DDD level that allow to decompose and merge Aggregates inside a Bounded Context.

_Note:_ Have a look into our [rapid prototyping tutorial](https://contextmapper.org/docs/rapid-ooad/) and [Olaf Zimmermann's blogpost](https://ozimmer.ch/practices/2020/06/10/ICWEKeynoteAndDemo.html) to learn how you can derive Bounded Contexts from subdomains automatically. These model transformations ease the shift from the «domain analysis» phase into the «Stratgic DDD» phase as illustrated above. Once you derived a Bounded Context from one or multiple subdomains, you can decompose it by using the ARs.

## Service Contract Generation
As soon as you prototyped your Context Map, the API's that integrate your subsystems (Bounded Contexts) become an important design issue. How shall they be designed/implemented and which parts of your domain models are exposed to other Bounded Contexts? Context Mapper offers you the possibility to generate [MDSL contracts](https://microservice-api-patterns.github.io/MDSL-Specification/) out of your CML Context Map. By using the [MDSL tools](https://microservice-api-patterns.github.io/MDSL-Specification/tools) you can even generate technology-specific contracts and code to rapidly prototype your applications later.

In CML you can declare which Aggregates are exposed in a Context Map relationship. Have a look at the following example:

<div class="highlight"><pre><span></span><span class="c">/* Example Context Map written with &#39;ContextMapper DSL&#39; */</span>
<span class="k">ContextMap</span> InsuranceContextMap {
  <span class="k">type</span> = <span class="k">SYSTEM_LANDSCAPE</span>
  <span class="k">state</span> = <span class="k">TO_BE</span>

  <span class="k">contains</span> CustomerManagementContext, CustomerSelfServiceContext

  <span class="err">CustomerManagementContext</span> <span class="err">[OHS</span>, PL]-&gt;[<span class="k">ACL</span>] CustomerSelfServiceContext {
    <span class="k">exposedAggregates</span> CustomersMainAggregate
    <span class="k">implementationTechnology</span> <span class="s">&quot;RESTful HTTP&quot;</span>
  }
}

<span class="c">/* Bounded Context Definitions */</span>
<span class="k">BoundedContext</span> CustomerSelfServiceContext {
  <span class="k">domainVisionStatement</span> = <span class="s">&quot;The customer self-service context provides a web application where customers can change their address.&quot;</span>
  <span class="k">type</span> <span class="k">FEATURE</span>
  <span class="k">responsibilities</span> <span class="s">&quot;Handle address change requests of customers&quot;</span>
  <span class="k">implementationTechnology</span> <span class="s">&quot;React Web Application&quot;</span>
  
  <span class="k">Aggregate</span> CustomerSelfServiceAggregate {
    <span class="k">Entity</span> UserAccount {
      <span class="k">String</span> username
      - <span class="k">Customer</span> accountCustomer
    }
    <span class="k">DomainEvent</span> CustomerAddressChanged {
      <span class="k">aggregateRoot</span>
      - <span class="k">UserAccount</span> issuer
      - <span class="k">Address</span> changedAddress
    }
  }
}

<span class="k">BoundedContext</span> CustomerManagementContext {
  <span class="k">domainVisionStatement</span> = <span class="s">&quot;The customer management context is responsible for managing all the data of the insurance companies customers.&quot;</span>
  <span class="k">type</span> <span class="k">FEATURE</span>
  <span class="k">responsibilities</span> <span class="s">&quot;Customers, Addresses&quot;</span>
  <span class="k">implementationTechnology</span> <span class="s">&quot;Java, JEE Application&quot;</span>

  <span class="k">Aggregate</span> CustomersMainAggregate {
    <span class="k">Entity</span> Customer {
      <span class="k">aggregateRoot</span>
      - <span class="k">SocialInsuranceNumber</span> sin
      <span class="k">String</span> firstname
      <span class="k">String</span> lastname
      - <span class="k">List</span>&lt;Address&gt; addresses
    }
    <span class="k">Entity</span> Address {
      <span class="k">String</span> street
      <span class="k">int</span> postalCode
      <span class="k">String</span> city
    }
    <span class="k">ValueObject</span> SocialInsuranceNumber {
      <span class="k">String</span> sin <span class="k">key</span>
    }
    <span class="c">/* added service operation */</span>
    <span class="k">Service</span> AddressService {
      <span class="k">boolean</span> changeAddress(@Address <span class="err">address</span>);
    }
  }
}
</pre></div>

_Note:_ In order to be able to generate contracts, an exposed Aggregate must at least contain one operation on the «Root Entity» or within a Service.

In the CML example above we used the two Bounded Contexts that we decomposed earlier in this blogpost. We have a customer management context and a self-service context that offers a web interface so that users can change their address by themselves. We further added a Context Map with a relationship between the contexts. Concretely: the self-service context needs the management context to change addresses. We added a service method `changeAddress` in the management context accordingly. The Aggregate that contains the service is marked as _exposed_ with the `exposedAggregates` keyword in the Context Map relationship.

Based on this information we can now generate an MDSL contract in Context Mapper:

![MDSL Generation in Visual Studio Code (Screenshot)](/media/092020-mdsl-generation-vscode-screenshot.png)

The generator produces the following simple MDSL contract:

<div class="highlight"><pre><span></span><span class="c">// Generated from DDD Context Map &#39;blog-demo.cml&#39; at 12.09.2020 16:04:15 CEST.</span>
<span class="k">API description</span> CustomerManagementContextAPI
<span class="k">usage context</span> <span class="k">PUBLIC_API</span> <span class="k">for</span> <span class="k">BACKEND_INTEGRATION</span> <span class="err">and</span> <span class="k">FRONTEND_INTEGRATION</span>

<span class="k">data type</span> Address { <span class="s">&quot;street&quot;</span>:<span class="k">D</span>&lt;<span class="k">string</span>&gt;, <span class="s">&quot;postalCode&quot;</span>:<span class="k">D</span>&lt;<span class="k">int</span>&gt;, <span class="s">&quot;city&quot;</span>:<span class="k">D</span>&lt;<span class="k">string</span>&gt; }

<span class="k">endpoint type</span> CustomersMainAggregate
  <span class="k">exposes</span>
    <span class="k">operation</span> changeAddress
      <span class="k">expecting</span>
        <span class="k">payload</span> Address
      <span class="k">delivering</span>
        <span class="k">payload</span> <span class="k">D</span>&lt;<span class="k">bool</span>&gt;


<span class="c">// Generated from DDD upstream Bounded Context &#39;CustomerManagementContext&#39; implementing OPEN_HOST_SERVICE (OHS) and PUBLISHED_LANGUAGE (PL).</span>
<span class="k">API provider</span> CustomerManagementContextProvider
  <span class="c">// The customer management context is responsible for managing all the data of the insurance companies customers.</span>
  <span class="k">offers</span> CustomersMainAggregate
  <span class="k">at</span> <span class="k">endpoint</span> <span class="k">location</span> <span class="s">&quot;http://localhost:8001&quot;</span>
    <span class="k">via</span> <span class="k">protocol</span> <span class="s">&quot;RESTful HTTP&quot;</span>


<span class="c">// Generated from DDD downstream Bounded Context &#39;CustomerSelfServiceContext&#39; implementing ANTICORRUPTION_LAYER (ACL).</span>
<span class="k">API client</span> CustomerSelfServiceContextClient
  <span class="c">// The customer self-service context provides a web application where customers can change their address.</span>
  <span class="k">consumes</span> CustomersMainAggregate
</pre></div>

The contract contains one `endpoint type` with the `changeAddress` operation and one `data type` to represent the address. In addition, it contains one `API provider` that offers the endpoint and one `API client` that consumes it.

For more MDSL examples and an introduction into the language I refer to the [MDSL website](https://microservice-api-patterns.github.io/MDSL-Specification/). [Olaf Zimmermann's blogpost](https://ozimmer.ch/practices/2020/06/10/ICWEKeynoteAndDemo.html) further shows how you can use the MDSL contract to generate technology-specific contracts such as Open API Specifications (OAS); see step 7 in his tutorial.

## Wrap Up
With the generation of MDSL contracts I am done illustrating our SummerSoC 2020 paper contributions using a fictitious example model.

In this post I gave a short introduction into service decomposition with strategic Domain-driven Design (DDD), Context Mapper with its Architectural Refactorings (ARs), our proposed incremental decomposition method, and contract generation with MDSL.

Please keep in mind that it is our goal to support domain/service modelers, software architects and software engineers by offering helpful tools that ease applying strategic DDD in projects. It is not our goal to replace the human work! The tools can hopefully support you, but you still need the people knowing your domain and the experience of modelers and architects to design good domain models and API's.

Do you have comments? Suggestions? You miss some features in Context Mapper? Please contact [me](https://stefan.kapferer.ch/about/)! I always appreciate feedback.

I hope you will give [Context Mapper](https://contextmapper.org/) a try ;)

Stefan

## Acknowledgements
This blogpost, the SummerSoC 2020 paper, and Context Mapper would not exist without [Olaf Zimmermann](https://ozimmer.ch/). Thank you very much for the great collaboration, teamwork, and all your support!

## UPDATE: SummerSoC Young Researcher Award 2020
Many thanks to the organizers of [SummerSoC 2020](https://www.summersoc.eu/) and [ServTech](https://servtech.info/) for [selecting me to receive the «SummerSoC Young Researcher Award 2020»](https://servtech.info/2020/09/14/summersoc-young-researcher-award-2020-goes-to-stefan-kapferer/) 🙏

![SummerSoC Young Researcher Award 2020 Picture (Stefan Kapferer)](/media/SummerSoC-Young-Researcher-Award-2020_Stefan-Kapferer.jpg)

It was a pleasure to be part of this event and of course I feel honored to receive this award!

Stefan

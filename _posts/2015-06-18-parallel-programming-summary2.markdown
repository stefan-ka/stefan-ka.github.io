---
layout:     post
title:      "Parallel Programming II"
subtitle:   "Summary 2: risks of concurrency, thread pools, task parallel library (TPL), GUI and threading"
date:       2015-06-17 15:55:00
author:     "Stefan Kapferer"
header-img: "img/062015-parallel-programming-summary1-bg.jpg"
tags:       [parallel programming, parallelism, concurrency, java]
---

## Introduction
This post is a continuation to my [previous summary](/2015/06/17/parallel-programming-summary1) of the course "Parallel Programming".

This are the chapter's:

 - risks of concurrency
 - Thread pools
 - Task Parallel Library
 

## Risks of concurrency
What are possible problems if we have concurrency?

 - Race conditions
      - Not enough synchronization
 - Deadlocks
      - mutual exclusion of threads
 - Starvation
      - fairness problems

### Race conditions
Race conditions leads to unexpected behaviors because multiple threads access shared resources without enough synchronization.
There are two different levels of race conditions:

 - data races (low-level)
 - semantically higher race conditions (high-level)
 
A program with race conditions is incorrect. There can be errors from time to time, but they are usually very hard to find.

#### Data races
Data races happen if threads access shared variables or objects and there is at least one writing access. (Read-Write, Write-Read, Write-Write)

#### Semantically higher race conditions
 - Critical sections not protected
      - Low-Level data races eliminated with synchronization
      - But not big enough synchronized blocks

### Should we synchronize everything?
It does not help if we just synchronize all methods. 
There can be semantically higher race conditions anyway and the synchronization is very expensive. (costs)

**When isn't synchronization needed?**

 - Immutability
      - Objects with read access only and final variables
 - Confinement
      - Object belongs only to one thread 

#### Immutable objects
 - all variables are *final*
 - methods with read access only
 - after constructor object can be used without synchronization (at least in java)
 
#### Confinement
Structure guarantees that object is only accessed by one thread at same time.
 
 - Thread confinement
      - Object is referenced from one thread
 - Object confinement
      - Object is encapsulated in an already synchronized object

### Thread safety
What means *thread safety*?

 - classes / methods which are synchronized internally
      - no data races
      - critical sections only inside methods
 - But:
      - Semantically higher race conditions still possible
      - other concurrency problems possible
 - There is no clear definition of this term

### Java collections and thread safety
Old java collections (Java 1.0) like *Vector, Stack, Hashtable* are threadsafe.
Modern collections (java.util > 1.0) like *HashSet, TreeSet, ArrayList, LinkedList, HashMap or TreeMap* are not threadsafe.
If you need concurrent collections, use classes in *java.util.concurrent*. (*ConcurrentHashMap, ConcurrentLinkedQueue, CopyOnWriteArrayList, ...*)

Why are the modern collections in java.util not threadsafe anymore?

 - often synchronization isn't needed => confinement
 - synchronization is mostly insufficient => elements not synchronized
 - old java 1.0 collections are historically threadsafe (backward compatibility)
 
#### Synchronized wrappers
It's also possible to use wrappers which synchronizes all methods. The elements are still not synchronized! (available for *List, Set, Collection, SortedList, SortedSet*)
{% highlight java %}
List list = Collections.synchronizedList(new ArrayList());
{% endhighlight %}

#### Iterating with concurrency
Iteration of a synchronized collection is not synchronized completely. Only single accesses are synchronized.
It's still possible that another thread changes the collection parallel to your iteration. (semantically higher race conditions)

### Nested Locks
Nested locks can lead to **deadlocks**. Example:

**Thread 1:**
{% highlight java %}
synchronized(listA) {
  synchronized(listB) {
    listB.addAll(listA);
  }
}
{% endhighlight %}
**Thread 2:**
{% highlight java %}
synchronized(listB) {
  synchronized(listA) {
    listA.addAll(listB);
  }
}
{% endhighlight %}
**What's the problem here?**
In the worst case, thread 2 will lock *listB* directly after thread 1 locked *listA*.
That scenario will block both threads because thread 1 is waiting for *listB* and thread 1 for *listA*. 

Programs with potential **Deadlocks** are incorrect:
 
 - threads can block each other
 - errors can happen sporadically 
 - difficult to find through tests
 
#### Special case: Livelocks
If threads block each other permanently but still use CPU, this is called livelock.
Example: 

**Thread 1:**
{% highlight java %}
b = false;
while (!a) { sleep(1); }
{% endhighlight %}
**Thread 2:**
{% highlight java %}
a = false;
while (!b) { sleep(1); }
{% endhighlight %}


## Sources
 - [HSR](http://www.hsr.ch): Module 'Parallele Programmierung' (ParProg)

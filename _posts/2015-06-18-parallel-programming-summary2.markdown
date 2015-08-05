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

 - Dangers of concurrency
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



## Sources
 - [HSR](http://www.hsr.ch): Module 'Parallele Programmierung' (ParProg)

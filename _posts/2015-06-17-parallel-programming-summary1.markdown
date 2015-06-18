---
layout:     post
title:      "Parallel Programming"
subtitle:   "Summary 1: Java Threads / Monitor synchronization / Synchronization Primitives"
date:       2015-06-17 15:55:00
author:     "Stefan Kapferer"
header-img: "img/062015-parallel-programming-summary1-bg.jpg"
tags:       [parallel-programming, parallelism, concurrency, java]
---

## Introduction
This summary is based on the course "Parallele Programmierung (ParProg)" from Luc Bläser at the [HSR](http://www.hsr.ch) in Rapperswil.
I visited the course in this years spring semester and now I want to make a little summary.

In this first post I like to write about following topics:

 - Multi-Threading basics
 - Monitor Synchronization
 - Specific Synchronization Primitives
    - Semaphore
    - Lock & Conditions
    - Count Down Latch
    - Cyclic Barrier
    - Phaser
    - Rendez-Vous
    - Exchanger
 
We work with Java, but the principles can be transfered to other languages.

## Parallelism vs. Concurrency
There are often confusions with the terms 'Parallelism' and 'Concurrency'.
This terms actually mean not the same, but they are two aspects of the same principle.

**Parallelism** basically means the splitting up of a process in simultaneously executable and collaborating sub-processes.

**Concurrency** means that two processes can start, run, and complete in overlapping time periods. 
They are independant but they compete for shared resources.

## Multithreading basics

### Process vs. Thread 
A **Process** is a heavy weight program instance. Each process has his own address space.

A **Thread** in contrast is a light weight parallel program instance inside a process. Threads share the same address space.

### Create a thread in Java

Implement a thread in java:
{% highlight java %}
class SimpleThread extends Thread {
   @Override
   publicvoidrun() {
      // threadbehavior
   }
}
{% endhighlight %}

Create thread instance:
{% highlight java %}
Thread myThread= newSimpleThread();
{% endhighlight %}

Start the thread:
{% highlight java %}
myThread.start();
{% endhighlight %}

A real thread is started only if you call the *start()* method. 
The *start()* method calls the *run()* method of the thread.
If a thread throws an unhandled exception, all other threads are still running.

### Runnable Interface
As an alternative to extend the class *Thread*, you can implement the *Runnable* interface.
{% highlight java %}
class SimpleLogic implements Runnable {
   @Override
   public void run() {
      // threadbehavior
   }
}

Thread myThread = newThread(newSimpleLogic());

myThread.start();
{% endhighlight %}

### Shorter with Java 8 Lambda
Ad-Hoc implementation of a 1-Method interface:
{% highlight java %}
Thread myThread = newThread(() -> {
   // threadbehavior
});

myThread.start();
{% endhighlight %}

### Anonymous inner class
{% highlight java %}
void startMyThread(final String label, final intnofIt) {
   newThread() {
      @Override public void run() {
         for (int i = 0; i < nofIt; i++) {
            System.out.println(i + " " + label);
         }
      }
   }.start();
}
…
startMyThread("A", 10);
startMyThread("B", 10);
{% endhighlight %}

### Thread methods

With **Thread.sleep(milliseconds)** you can put a thread in the waiting state. After *milliseconds* he will go to ready state again.

**Thread.yield()** forces the thread to release the processor. (forces thread switch)

**Thread.join()** blocks until the thread is terminated. After a thread is terminated *t.isAlive()* will be *false*.

### InterruptedException

 - It's possible that blocking methods (*sleep()*, *join()*) throw an InterruptedException
 - Threads can be interrupted from outside: *myThread.interrupt()*

## Monitor synchronization
Threads have to share their address space and heap. They can access same objects and variables.
That's why access to resources have to be synchronized enough, otherwise race conditions are possible. (uncontrolled or wrong interactions between threads)

### Critical Section
Methods or code blocks which should be executed by only one thread at one time are called **Critical sections**.
No parallel execution should be possible for this sections. (mutual exclusion)

### Java Synchronized Methods
With the *synchronized* modifier, the body of a method is marked as *critical section*:
{% highlight java %}
class BankAccount {
   private intbalance = 0;

   public synchronized void deposit(int amount) {
      this.balance += amount;
   }
}
{% endhighlight %}

**How does *synchronized* work?**<br />
Each object has a lock (monitor lock) and only one thread at a time
can have this lock. If a thread enter's a synchronized block he takes the lock if it's free.
Otherwise he has to wait until the lock gets free.

If you add the synchronized modifier to multiple methods in the class, only one thread can enter one of this methods at one time.

### Synchronized Statement Blocks
With synchronized statement blocks you can mark critical sections inside methods.
Additionally you can define the Lock-Object explicitly.

In this example we make a monitor lock on *this*:
{% highlight java %}
class BankAccount {
   private intbalance = 0;

   public void deposit(int amount) {
      synchronized(this) {
         this.balance += amount;
      }
      System.out.println("Deposit done");
   }
}
{% endhighlight %}

#### Equivalent usage
The following example ...
{% highlight java %}
public class Test {
   synchronized void f() { ... } // Object Lock
   static synchronized voidg () { ... } // Class Lock
}
{% endhighlight %}

... is equal to ...

{% highlight java %}
public class Test {
   void f() {
      synchronized(this) { ... } // Object Lock
   }
   
   static void g() {
      synchronized(Test.class) { ... } // Class Lock
   }
}
{% endhighlight %}

### Wait & Signal Mechanism
With the *Wait & Signal* mechanism threads can wait for conditions.
Threads can also signal other threads to wake up.

 - *wait()* releases the monitor lock temporary. Thread is inactive until wakeup.
 - *notify()* wakes a specific thread
 - *notifyAll()* wakes all threads which are waiting for entering the monitor
 
Example:
{% highlight java %}
class BoundedBuffer<T> {
   private Queue<T> queue = new LinkedList<>();
   int limit; // initialize in constructor

   public synchronized void put(T x) throws InterruptedException {
      while(queue.size() == limit) {
         wait(); // await non-full
      }
      queue.add(x);
      notifyAll(); // signal non-empty
   }

   public synchronized T get() throws InterruptedException {
      while (queue.size() == 0) {
         wait(); // await non-empty
      }
      T x = queue.remove();
      notifyAll(); // signal non-full
      return x;
   }
}
{% endhighlight %}

#### Efficiency problem
 - With multiple conditions
    - *notifyAll()* wakes all threads
    - all threads enter monitor one after another
    - condition maybe only for one thread fulfilled
    - all other threads call *wait()* again
 - context switches
 - high synchronization costs

#### Fairness Problem
In Java you cannot be sure that you have a FIFO queue, so it's
possible that you have threads which never wake up. (reason to use *notifyAll()*)

## Specific Synchronization Primitives

### Semaphore
A semaphore is an object with a counter that counts the amount of free resources.
With the *acquire()* method you can get one resource and the counter decrements.
*release()* passes the resource back and the counter increments.

![Semaphore](/media/062015-parallel-programming-summary1-semaphore.png)

**A semaphore with a counter which can only be 0 or 1 is called *Binary Semaphore*.**

#### Fair semaphore
By default the semaphore in Java is not fair.
If you like a fair semaphore you have to pass an additional parameter to the constructor:
{% highlight java %}
new Semaphore(N, true)
{% endhighlight %}
In this case the semaphore uses a FIFO queue.

#### Multi-Acquire/Release
You can also acquire and release multiple resources:
{% highlight java %}
acquire(int permits)

release(int permits)
{% endhighlight %}

### Lock & Conditions
The *Lock & Conditions* primitive is basically a monitor with multiple waiting lists for different conditions.

 - Lock-Object: Lock for entering monitor
 - Condition-Object: Wait & Signal for conditions
 - Multiple conditions per lock possible

![Lock & Conditions](/media/062015-parallel-programming-summary1-lock-and-condition.png)

Example:
{% highlight java %}
class BoundedBuffer<T> {
   private Queue<T> queue = new LinkedList<>();
   private Lock monitor = new ReentrantLock(true);
   private Condition nonFull = monitor.newCondition();
   private Condition nonEmpty = monitor.newCondition();   
   
   public void put(T item) throws InterruptedException {
      monitor.lock();
      try {
         while (queue.size() == Capacity) { 
            nonFull.await(); 
         }
         queue.add(item);
         nonEmpty.signal();
      } finally { 
         monitor.unlock(); 
      }
   }

   public T get() throws InterruptedException {
      monitor.lock();
      try {
         while (queue.size() == 0) { 
            nonEmpty.await(); 
         }
         T item = queue.remove();
         nonFull.signal();
         return item;
      } finally { 
         monitor.unlock(); 
      }
   }
}
{% endhighlight %}

#### Read-Write Lock
Mutual exclusion often is not needed for read access but for write access.
In this case you can use ReadWrite-Locks.

Example:
{% highlight java %}
class NameDatabase {
   private Collection<String> names = new HashSet<>();
   private ReadWriteLock rwLock = new ReentrantReadWriteLock(true);

   public Collection<String> find(String pattern) {
      rwLock.readLock().lock();
      try {
         return names.stream().
            filter(n -> n.matches(pattern));
      } finally {
         rwLock.readLock().unlock();
      }
   }

   public void put(String name) {
      rwLock.writeLock().lock();
      try {
         names.add(name);
      } finally {
         rwLock.writeLock().unlock();
      }
   }
}
{% endhighlight %}

**ReadWriteLocks with conditions:** Conditions are supported for WriteLocks only!

### Count Down Latch
A *count down latch* is a synchronization primitive with a counter.
This is used if all threads wait for one single condition. When the condition is fulfilled, all threads will work further.
The counter can be decremented by threads with the method *countDown()*.
Threads can wait until the counter is zero with the *await()* method.

Example:
All Cars have to wait for the startSignal.
And the startSignal must wait until all cars are ready.
{% highlight java %}
CountDownLatch carsReady = new CountDownLatch(N);
CountDownLatch startSignal = new CountDownLatch(1);

N Cars:                                     RaceControl:
carsReady.countDown(); -------------------> carsReady.await();
startSignal.await(); <--------------------- startSignal.countDown();

{% endhighlight %}

Latches can only be used once. You cannot reset the counter.
If you need a new synchronization you have to create a new latch.

### Cyclic Barrier

 - A cyclic barrier is a meeting point for a fixed amount of threads. The threads can wait until all other threads arrived. (*await()*)
 - The amount of threads must be defined from beginning.
 - Cyclic Barrier's are re-usable
 
The barrier closes automatically for next round:
{% highlight java %}
CyclicBarrier gameRound = new CyclicBarrier(N);

while (true) {
   gameRound.await();
   // play concurrently with others
}
{% endhighlight %}
![Cyclic Barrier](/media/062015-parallel-programming-summary1-barrier.png)

### Phaser
 - is a generalized cyclic barrier
 - participants can register and de-register (effective in next round)
 
Player-Thread:
{% highlight java %}
phaser.register();
while (…) {
   phaser.arriveAndAwaitAdvance();
   playRound();
}
phaser.arriveAndDeregister();
{% endhighlight %}

### Rendez-Vous
 - barrier with information exchange
 - special case: 2 participants
 - 2 threads meet und exchange objects
 
### Exchanger
 - blocks, until other thread calls *exchange()*
 - provides argument x of the other thread

![Exchanger](/media/062015-parallel-programming-summary1-exchanger.png)


## Sources
 - [HSR](http://www.hsr.ch): Module 'Parallele Programmierung' (ParProg)

---
layout:     post
title:      "Autopilot for carrera slot car"
date:       2016-01-12
summary:    A challenge project at HSR&colon; akka-based autopilot for a carrera slot car.
---

## Introduction
Yesterday I finished a very cool project with one of my fellow students (Roberto) at the [HSR](http://www.hsr.ch) in Rapperswil.
It was the module called 'challenge project' and was done by several groups.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Finished our exciting Challenge-Project <a href="https://twitter.com/HSR_Informatik">@HSR_Informatik</a> yesterday evening. 🏁 <a href="https://t.co/UMdWk2jJae">https://t.co/UMdWk2jJae</a> <a href="https://t.co/H8HSwBcQVT">https://t.co/H8HSwBcQVT</a></p>&mdash; Stefan Kapferer (@stefankapferer) <a href="https://twitter.com/stefankapferer/status/686869040707596289">January 12, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

What we did? We implemented an autopilot for a carrera slot car... The project was organized by [Zühlke](http://www.zuehlke.com). (Many thanks to Wolfgang for the nice challenge!)

The project included a lot of topics which are in high demand these days. For example:

 - [reactive programming](https://en.wikipedia.org/wiki/Reactive_programming)
 - [akka](http://akka.io)
 - real time event processing
 - [machine learning](https://en.wikipedia.org/wiki/Machine_learning)
 - data analytics
 - [IoT (internet of things)](https://en.wikipedia.org/wiki/Internet_of_Things)

... just to name some of them ;-)

## The challenge
What was the challenge? We wrote an autopilot for a carrera slot car. The data we had to accomplish that, was just one GYRO-Sensor on the car. And we only had the GYRO-Z-value to use. 
Yes... It was a challenge :-)

The pilot had to recognize the track automatically. (it had to work on any track) After he has a model of the track he must optimize the speed.
In the end of the project we had a race with the other groups. Best algorithm wins...



## The solution (simplification)
Simply explained, we splitted the algorithm in two phases. First we made the track recognition. With the GYRO-Sensor we recognized if we are driving LEFT, RIGHT or STRAIGHT.
Based on that data, we generated patterns how the track possibly looks like. We try to prove these patterns and after a few rounds on the track, we know the correct pattern. 

Second phase is the speedup phase... We just speeded up the STRAIGHT parts. (for the curves was no more time) We just give full power (255) in the beginning of a straight part, and then we brake down (nearly to zero power) at the end of the part. The target is to maximize the time until we have to brake down.

In the following object diagram you get an overview over the main actors (akka) we had in our system for a simple track:

[![actor-design](/media/012016-autopilot-object_diagram.png)](/media/012016-autopilot-object_diagram.png)

We also had to make a lot of data analytics. Here you can see an example how we visualized the GYRO-Data from the sensor and the round-times of the current race:
[![actor-design](/media/012016-autopilot-screenshot_data_analyzer.png)](/media/012016-autopilot-screenshot_data_analyzer.png)

If you want to know more about the design of our project, everything we did is on our project site [http://hsr-challp1-whitespace.github.io/](http://hsr-challp1-whitespace.github.io/). 

## Training video
In the following video you can see an example of one of our trainings, to get an idea: 

<iframe width="560" height="315" src="https://www.youtube.com/embed/P93yaSXcMYY" frameborder="0" allowfullscreen></iframe>

As you can imagine, the project was a lot of fun ;-)

## More to our project
 - Everything we did in our project you can find here: [http://hsr-challp1-whitespace.github.io/](http://hsr-challp1-whitespace.github.io/)
 - The source code: [https://github.com/HSR-ChallP1-Whitespace/autopilot](https://github.com/HSR-ChallP1-Whitespace/autopilot)









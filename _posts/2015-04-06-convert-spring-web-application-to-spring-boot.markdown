---
layout:     post
title:      "Spring Boot"
subtitle:   "Convert existing Spring MVC application to Spring Boot"
date:       2015-04-06 17:00:00
author:     "Stefan Kapferer"
header-img: "img/042015-convert-spring-mvc-to-spring-boot-bg.jpg"
tags:       [java, spring, spring-boot, spring-mvc]
---

## Convert an existing Spring MVC application to Spring Boot

Until now I runned my web applications which I made with [Spring MVC](https://spring.io/guides/gs/serving-web-content/) on a servlet container like [Apache Tomcat](http://tomcat.apache.org/).
Sometimes, if you like to start the application on a new machine it's hard to get them running. You have to download Tomcat, deploy the app, and so on... It would be nice to start them like normal Java applications. For this reason I like to run my [sample application](https://github.com/stefan-ka/FAITH-ServerComponent/tree/spring-boot) with [Spring Boot](http://projects.spring.io/spring-boot/). [Spring Boot](http://projects.spring.io/spring-boot/) will use an embedded tomcat to start the app. 

Here wo go...

### Dependencies

My sample project is build with maven.
First I have to add the "spring-boot-starter-web" dependency to my project:
{% highlight xml %}
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <version>${spring-boot-version}</version>
</dependency>
{% endhighlight %}

For some reasons, in my case, spring was missing the aspectj-Library when starting
the application with spring boot. So I also added it:
{% highlight xml %}
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.8.5</version>
</dependency>
{% endhighlight %}


### Create executable application class

With the **@SpringBootApplication** Annotation you can tell [spring boot](http://projects.spring.io/spring-boot/), which class should be your executable application class.
To start the application you have to use the method SpringApplication.run().

Here you see my example:

{% highlight java linenos %}
package ch.hsr.faith.application.rest;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(
				"classpath:/META-INF/rest-services-config.xml", args);
	}

}
{% endhighlight %}

The first parameter of the run()-Method takes the path to my spring-config-xml, I already had before, as a string.

### Remove traditional "webapp" folder

In my [Spring MVC application](https://spring.io/guides/gs/serving-web-content/) I had a "webapp" folder with the web.xml file, spring configuration files, and other properties-Files.
My new [Spring boot app](http://projects.spring.io/spring-boot/) does not need the web.xml anymore, so I deleted it.
The other config-files I moved to the **src/main/resources/META-INF directory**:

{% highlight bash %}
renamed:    src/main/webapp/WEB-INF/config/database.properties -> src/main/resources/META-INF/database.properties
renamed:    src/main/webapp/WEB-INF/config/repository-context.xml -> src/main/resources/META-INF/repository-context.xml
renamed:    src/main/webapp/WEB-INF/config/rest-services-config.xml -> src/main/resources/META-INF/rest-services-config.xml
renamed:    src/main/webapp/WEB-INF/config/security-config.xml -> src/main/resources/META-INF/security-config.xml
deleted:    src/main/webapp/WEB-INF/web.xml
{% endhighlight %}

### Add maven plugin

To run my app with maven, I use the **spring-boot-maven-plugin**.
So I added it to my POM-File:
{% highlight xml %}
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <version>${spring-boot-version}</version>
        </plugin>
    </plugins>
</build>
{% endhighlight %}

### Run the application

Now I'm able to run my spring boot application with the following command:
{% highlight bash %}
mvn spring-boot:run
{% endhighlight %}

And it works! That was very easy...

{% highlight bash %}
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v1.2.2.RELEASE)
...
2015-04-06 16:30:49.232  INFO 9051 --- [lication.main()] s.b.c.e.t.TomcatEmbeddedServletContainer : Tomcat started on port(s): 8080 (http)
2015-04-06 16:30:49.234  INFO 9051 --- [lication.main()] c.h.faith.application.rest.Application   : Started Application in 6.522 seconds (JVM running for 8.888)
{% endhighlight %}

![Running app](/media/042015-convert-spring-mvc-to-spring-boot-running-app.png)



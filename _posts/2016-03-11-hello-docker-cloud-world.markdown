---
layout:     post
title:      "Hello Docker Cloud World"
date:       2016-03-11
summary:    Hello World with Docker & Docker Cloud.
---

## Introduction
Last week [Docker](http://www.docker.com) announced its own cloud service:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Announcing <a href="https://twitter.com/docker">@Docker</a> <a href="https://twitter.com/hashtag/Cloud?src=hash">#Cloud</a>, new cloud service by <a href="https://twitter.com/hashtag/Docker?src=hash">#Docker</a> expanding on <a href="https://twitter.com/tutumcloud">@tutumcloud</a> features: <a href="https://t.co/tAiBgRy4wr">https://t.co/tAiBgRy4wr</a> <a href="https://t.co/kOHPhx1fJz">pic.twitter.com/kOHPhx1fJz</a></p>&mdash; Docker (@docker) <a href="https://twitter.com/docker/status/704675557271859200">March 1, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

To try it out, I created a small 'Hello World' web app, and deployed it to the docker cloud.

## Create a 'hello world' and dockerize it
For my 'hello world' I decided to create a simple [Spring Boot](http://projects.spring.io/spring-boot/) application, because its created very quickly and I don't need any application server or servlet container.

To dockerize the application I created a Dockerfile:

{% highlight dockerfile %}
FROM java:8

# Install maven to build project
RUN wget --no-verbose -O /tmp/apache-maven.tar.gz http://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
RUN echo "516923b3955b6035ba6b0a5b031fbd8b /tmp/apache-maven.tar.gz" | md5sum -c
RUN tar xzf /tmp/apache-maven.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.3.9 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven.tar.gz
ENV MAVEN_HOME /opt/maven
ENV PATH $MAVEN_HOME/bin:$PATH

WORKDIR /app

# Add POM and source
ADD pom.xml /app/pom.xml
ADD src /app/src

# Build the app
RUN ["mvn", "clean", "package"]

# Run the app
RUN bash -c 'touch /app/target/hello-world-0.0.1-SNAPSHOT.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app/target/hello-world-0.0.1-SNAPSHOT.jar"]
{% endhighlight %}

As you can see, I used [Maven](https://maven.apache.org/) to build the project. I just took the Java-8 Image and added Maven manually. I'm new with docker, so maybe this isn't the best way, but it works for my 'Cloud hello world'.

You can find the whole project on Github: [https://github.com/stefan-ka/spring-boot-docker-helloworld](https://github.com/stefan-ka/spring-boot-docker-helloworld)

Now I can build and run the docker container very easy:

{% highlight bash %}
docker build -t my-hello-world .
docker run -d -p 8080:8080 my-hello-world
{% endhighlight %}

## Docker Hub
Docker allows you to push your Images to [Docker Hub](https://hub.docker.com). You can create a repository directly on Docker Hub, or link Docker Hub with your Github repository. As you already saw above, I created a GitHub-Repo.

To make the image available inside Docker Hub and build the Image there, you can create an "Automated build". Make sure you have linked your Docker Hub account with your Github account.

From your Docker Hub Dashboard you can click "Create" and then "Create Automated Build". Then you can choose between Github and Bitbucket:
![Create Automated Build](/media/032016-DockerCloud-CreateAutomatedBuild.png)

Choose Github and select your repository. In the end you can define a name for your automated build, give a short description, and define its visibility:
![Create Automated Build](/media/032016-032016-DockerCloud-CreateAutomatedBuild-Finish.png)

After you have created your automated build you can trigger a build by pushing some changes to the repository, or manually trigger it on tab 'Build settings'. After that, you can check the build status on tab 'Build Details':
![Successfull automated build](/media/032016-DockerCloud-SuccessfulBuild.png)

Make sure that your build is successful before continuing with docker cloud setup.

## Run the image in the docker cloud
You can login to the [Docker Cloud](https://cloud.docker.com) with your Docker-Hub account. 
First you have to link your account with a cloud provider. For my 'hello world' I used Amazon Web Services:
![Cloud Providers](/media/032016-DockerCloud-Provider-AmazonWebServices.png)

You can find a description how to link the docker cloud account with your amazon account [here](https://docs.docker.com/docker-cloud/getting-started/link-aws/).

After you linked those accounts your first have to create a Node. On tab "Nodes", click "Launch your first node":
![Launch first Node](/media/032016-DockerCloud-Launch-first-Node.png)

Type a name for your node, maybe you want to select another region, and select your node size:
![Create a Node Cluster](/media/032016-DockerCloud-Create-Note-Cluster.png)

Click "Launch node cluster"...

Your node is now deploying, this can take some minutes:
![Node is deploying](/media/032016-DockerCloud-Node-Is-Deploying.png)

The next step is creating a service. Go to service tab and click "Create your first service":
![Create your first service](/media/032016-DockerCloud-Create-first-Service.png)

Now you can select your repository from Docker Hub under "My repositories":
![Select your repository](/media/032016-DockerCloud-Select-Repo.png)
Click "Launch" on the repository you want to use for your service.

Then you can configure your service:
![Configure your service](/media/032016-DockerCloud-ConfigureService.png)

In my case I added a port-mapping, so that my container port 8080 is mapped to port 80.
I also enabled Autoredeploy. This is very cool, if enabled, your application will redeploy automatically if you push something to your Git-Repository.

When you have configured everything, click "Create service".

You will be redirected to the follwing page, where you just can click "Start", to run your service on your node:
![Start your first service](/media/032016-DockerCloud-StartService.png)

The service is starting now. This can take some time. When your service is running, you can find a link to your application under endpoints:
![Endpoints](/media/032016-DockerCloud-Endpoints.png)

Click on the link, and voilà:
![Runnning Hello World](/media/032016-DockerCloud-Running-Hello-World.png)

The 'hello world' application is up and running inside the docker cloud.

If you push something to your Git-Repo, the Docker Hub will automatically build your image and Docker Cloud will redeploy your app.


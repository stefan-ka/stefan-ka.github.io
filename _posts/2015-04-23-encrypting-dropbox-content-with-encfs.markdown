---
layout:     post
title:      "Secure cloud storage"
subtitle:   "Encrypting Dropbox content with EncFS"
date:       2015-04-25 17:45:00
author:     "Stefan Kapferer"
header-img: "img/042015-encrypt-dropbox-content.jpg"
tags:       [encryption, cloud]
---

## Encrypting Dropbox content with EncFS
Everybody uses cloud storage systems like [Dropbox](http://www.dropbox.com). I also use it. I like to store files like PDF's on a place where I can easily access them from my smartphone or my tablet. But the problem that there is no data security with this cloud solutions bothers me. Thats why I recently had the idea to encrypt the files I store in my dropbox.

My requirements are that I can use the Dropbox on my Notebook (Linux: Ubuntu) and on my Android devices.
That brought me to [EncFS](https://vgough.github.io/encfs/), because its very easy to use on linux systems (natively) and there are Android Apps available to decrypt it.

### Setup
The setup of [EncFS](https://vgough.github.io/encfs/) is very easy on Linux.
On Ubuntu use apt-get to install it first:
{% highlight bash %}
sudo apt-get install encfs
{% endhighlight %}

Now I setup an encrypted Folder for my Dropbox. EncFS uses a mirrored unencrypted local folder. Every file you put into this folder will be encrypted to the 'encrypted' Folder. 

**Important:**
Never directly store a file into the encrypted folder. It will not be encrypted and synchronized to your Dropbox.

To setup the folder I use the following command:
{% highlight bash %}
encfs ~/Dropbox/.encrypted ~/DropboxSecure
{% endhighlight %} 
The '**~/Dropbox/.encrypted**' folder will be my encrypted folder inside the Dropbox.
The '**~/DropboxSecure**' folder is the unencrypted folder where I have to save my files.

Now EncFS will ask for a setup mode:
{% highlight bash %}
Creating new encrypted volume.
Please choose from one of the following options:
 enter "x" for expert configuration mode,
 enter "p" for pre-configured paranoia mode,
 anything else, or an empty line will select standard mode.
{% endhighlight %}

I used the expert configuration to see what the different settings are. Here a summary of my configuration:
{% highlight bash %}
Cipher algorithm:                                    AES
Key size:                                            256 bits
File system block size:                              4096
File name encoding:                                  Block
Enable filename initialization vector chaining:      Yes
Enable per-file initialization vectors:              Yes
Enable filename to IV header chaining:               No
Enable block authentication code headers
on every block in a file:                            No
Add random bytes to each block header:               8
Enable file-hole pass-through:                       Yes
EncFS Password:                                      ●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●●
{% endhighlight %}

That's it. The folder is now set up.

#### Mount EncFS folder permanently
Your folder which is now mounted, will not be mounted permanently. After a reboot you have to mount it again!
It's not that difficult, you just have to call this command again:
{% highlight bash %}
encfs ~/Dropbox/.encrypted ~/DropboxSecure
{% endhighlight %} 
This time you call it, it will just ask you for your password and that's it.

I like that this is done automatically each time I boot my laptop. For that reason I wrote a small script that mounts the folder automatically. For that case you have to store your password somewhere. I just wrote it to a text file. I know this could be another security problem, but if it's only located on my machine and can not be uploaded to the dropbox it is okay for me at the moment.

Basically you have to make sure this command is called at boot time:
{% highlight bash %}
cat ~/someFolderOnMyMachine/textFileWithMyPassword.txt | encfs ~/Dropbox/.encrypted ~/DropboxSecure -S
{% endhighlight %} 

I added it to my login script.


### Test it
Now I can store any file to my DropboxSecure folder...:
![Store file to unencrypted folder](/media/042015-Encrypting-Dropbox-Content-Shot1.png)

... and it will be stored encrypted to my Dropbox folder:
![Store file to unencrypted folder](/media/042015-Encrypting-Dropbox-Content-Shot2.png)

### Access files on Android
As I sad at the beginning, I want to access my Files from my Android devices.
There are different Apps which can decrypt an EncFS volume, you can search for them.
I used [Encdroid](https://play.google.com/store/apps/details?id=org.mrpdaemon.android.encdroid), which you can find in the play store: [https://play.google.com/store/apps/details?id=org.mrpdaemon.android.encdroid](https://play.google.com/store/apps/details?id=org.mrpdaemon.android.encdroid)

When you have started the app you can link the app with your Dropbox Account under the settings menu "Accounts".
Then you can import the volume with the "Import Volume" Menu:

<div style="float:left;padding-bottom:20px;">
	<img src="/media/042015-Encrypting-Dropbox-Content-AndroidShot1.png" style="float:left; padding:10px 10px 0px 0px;" />
	<img src="/media/042015-Encrypting-Dropbox-Content-AndroidShot2.png" style="float:left; padding:10px 10px 0px 0px;" />
	<img src="/media/042015-Encrypting-Dropbox-Content-AndroidShot3.png" style="float:left; padding:10px 10px 0px 0px;" />
	<img src="/media/042015-Encrypting-Dropbox-Content-AndroidShot4.png" style="float:left; padding:10px 10px 0px 0px;" />
</div>

Now open the volume, enter the password, and you can access your files:

<div style="float:left;padding-bottom:20px;">
	<img src="/media/042015-Encrypting-Dropbox-Content-AndroidShot5.png" style="float:left; padding:10px 10px 0px 0px;" />
	<img src="/media/042015-Encrypting-Dropbox-Content-AndroidShot6.png" style="float:left; padding:10px 10px 0px 0px;" />
	<img src="/media/042015-Encrypting-Dropbox-Content-AndroidShot7.png" style="float:left; padding:10px 10px 0px 0px;" />
</div>

### Conclusion
With EncFS it's very easy to create an encrypted folder under linux an sync it with your dropbox. Also the access from Android devices is done quickly.

Unfortunately there are some **security issues**. While I wrote this post I found a Report of a [Security Audit](https://defuse.ca/audits/encfs.htm) of EncFS.
They say that there are security problems if multiple snapshots of your encrypted file are available. This could be a problem because of course I will save multiple versions of my files into my dropbox.

But in the short time I had, I could not find another solution which also works with my Linux/Android setup that easy.
I have to make some further investigation later if there are better (more secure) solutions.

Ideas are welcome. How do you do it?




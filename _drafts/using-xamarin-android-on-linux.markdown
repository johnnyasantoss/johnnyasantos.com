---
layout: post
title: Using Xamarin.Android on Linux
---


<div class="wp-block-jetpack-markdown">Hello!

I’m going to explain how I made Xamarin.Android run on Linux.

This *workaround* still working today.

### Install the latest stable Mono

- Go to the [download page](https://www.mono-project.com/download/vs/) and follow the instructions there.
- Install the packages **`mono-complete`** and **`msbuild`**.

eg. On Ubuntu  
`$ sudo apt-get install mono-complete msbuild`

### Install OpenJDK 8

Using the default package manager on your computer, install the **`openjdk-8-jdk`** package.

eg. On Ubuntu  
`$ sudo apt-get install openjdk-8-jdk`

Or refer to Open JDK [install page](https://openjdk.java.net/install/) to check how to install it.

### Download Android SDK and NDK

You can accomplish this by using [JetBrains Rider](https://www.jetbrains.com/rider/download/#section=linux), [Android Studio](https://developer.android.com/studio/) or the command line.

#### Using JetBrains Rider

#### Using the command line

#### Using Android Studio

*I personally don’t recommend using Android Studio to do this because it is such a big download just so you can use one of its tools to install the SDK. I don’t think it will be as efficient as using the command line.*

- [Install](https://developer.android.com/studio/install#linux) the IDE in your machine.
- Follow [these steps](https://developer.android.com/studio/intro/update#sdk-manager) to install the SDK and the NDK in your machine.

### Downloading the binaries from Xamarin’s CI

</div>

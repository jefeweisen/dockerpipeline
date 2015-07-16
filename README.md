# Docker for AI2 Pipeline Applications

[The Allen-AI Pipeline Framework](https://github.com/jefeweisen/pipeline) ("AI2 Pipeline" or "AIP" for short) is a library for building reproducible data pipelines to support experimentation.

dockerpipeline is a startup kit for AIP.

dockerpipeline integrates:

  - docker, to containerize
  - boot2docker to host the docker container
  - virtualbox, to host boot2docker, and (through its file sharing) to support curation of data
  - A sample program copied from AIP, to help you hit the ground running

To minimize startup time, we include headless commands for installing matching versions of the prerequisite software.  We test the installations on OS X and Windows host machines.

### The AI2 Pipeline in a Docker container

Reproducibility in data analysis means that behavior of the analysis has to be completely captured by the code and data that went into the analysis.  The Java Virtual Machine (JVM) sandboxes much behavior of AIP-based applications.  But AIP also supports external OS subprocesses as data producers.  For containing the variation of subprocess behavior, docker is a good fit.

The configured software package versions are tested together so that teams with mixed workstation operating systems can collaborate.  Mac OS, Windows, and Linux users can all share reproducible data science if each runs AIP in a Docker container.

### Getting experimental work done inside a docker container

We recommend IntelliJ 14 in conjunction with its recent Docker Integration plugin.  The Docker Integration plugin automatically triggers "docker build", "docker run", and connection to the debugger every time you perform "Run | Debug".

Access to an IDE can be more important when developing software inside containers.  Containers by their nature restrict activities like file editing, and software in containers often lacks much console user interface software.

To get you started quickly, this docker integration comes with a copy of one of the AIP sample pipelines.  Upon building, this sample code will get you started writing AIP pipeline application code.

## Prerequisites

Required:
- JDK 7 or newer (tested with sun JDK 1.8.0_45)
- SBT 0.13.5 or better (tested with 0.13.7)
- Vagrant (tested with version 1.7.2)
- Virtualbox (tested with version 4.3.14)
- Docker client (tested with version 1.6.0)
- IntelliJ 14, with scala plugin.  Community Edition (free of cost) suffices.

Recommended:
- The IntelliJ Docker Integration plugin

Optional alternative:
- Bring your own docker container host, instead of using the integrated boot2docker build.

Coming soon:
- SBT command line build of the docker images.  Not yet supported.

Workstations based on Mac OS and Microsoft Windows have been tested.  Headless install instructions for the dependencies on each are included in the documentation.  A build for boot2docker is provided so that teams with heterogenous workstation OSes can use the same Docker container host VM.

### How to install IntelliJ Docker Integration:

The Jetbrains Docker plugin for IntelliJ 14 is called "Docker Integration".  More details available at:

http://blog.jetbrains.com/idea/2015/03/docker-support-in-intellij-idea-14-1/


The Jetbrains Scala plugin for IntelliJ 14 is called "scala".


## Installation


### Step 1: Setup

Clone this repository.  Obtain the chvdocker repository through a submodule:

    git submodule init
    git submodule update

One-time dependency setup, including hosting for the docker container:

    tools/buildPipeline.sh  # build AIP
    chvdocker/tools/virtualbox_image_download.sh
    tools/vagrant.sh up     # start a VM to host docker containers
    . chvdocker/tools/env.sh
    tools/extract_my_docker_certs.sh
    tools/dockerbuild.sh    # docker build will take longer the first time
    tools/vagrant.sh halt

These repositories also contribute functionality behind the scenes:

https://github.com/jefeweisen/chvdocker
https://github.com/jefeweisen/boot2docker-vagrant-box


### Step 2: Build/Run

To start and stop the vm, instead of using 'vagrant' by itself, use this wrapper script to keep the other pieces of dockerpipeline working together:

    tools/vagrant.sh up
    tools/vagrant.sh halt

#### Build/Run Option 1: From the command line

    . chvdocker/tools/env.sh
    tools/dockerbuild.sh
    tools/dockerrun.sh

Correct behavior of the sample code looks like this:

    hello docker
    22:02:34.297 [main] DEBUG o.a.pipeline.ProducerWithPersistence - CountWords computing value
    22:02:34.305 [main] DEBUG o.a.pipeline.ProducerWithPersistence - CountWords reading from FileArtifact[/pipeline-output/data/CountWords.b74ef3a24d39b78f.json] using org.allenai.pipeline.SingletonIo@7efceaf5
    22:02:34.349 [main] DEBUG o.a.pipeline.ProducerWithPersistence - CountWords returning value
    22:02:34.355 [main] DEBUG o.a.pipeline.ProducerWithPersistence - CountLines computing value
    22:02:34.362 [main] DEBUG o.a.pipeline.ProducerWithPersistence - CountLines reading from FileArtifact[/pipeline-output/data/CountLines.86026d37cd1ad494.txt] using org.allenai.pipeline.SingletonIo@16e6a1e5
    22:02:34.364 [main] DEBUG o.a.pipeline.ProducerWithPersistence - CountLines returning value
    22:02:34.368 [main] INFO  o.allenai.pipeline.Pipeline$$anon$3 - Ran pipeline in 0.078 s
    22:02:34.645 [main] INFO  o.allenai.pipeline.Pipeline$$anon$3 - Summary written to /pipeline-output/summary/Count-words-and-lines-...html

After a successful run, you should find a .html summary in the directory:

    moveme_pipeline-output/summary/Count-words-and-lines-...html


#### Build/Run Option 2: From Intellij

Import build.sbt with IntelliJ.  Then:

    sbt setupIntellij

The setupIntellij task tells intellij that it wants to send a .jar to docker via the dockerbuild/ directory.

Now create a run configuration:

    - On the top menu bar: Run | Edit Configurations

    - Dialog box is titled Run/Debug Configurations

        Add a configuration:

            Click +

            Select "Docker deployment"

            Name: docker1
            Server:
                name: boot2docker_virtualbox_1-6-0
                API URL: https://127.0.0.1:2376
                Certificates folder: $HOME/.docker/docker_1.6.0
                    ClientProtocolException
            Image tag: dockerpipeline
            Container name: containerfoo
            Container settings: <your source code dir>/dockerpipeline/config/container_settings.json
            Debug port: 4000
                debug string will be automatically generated from port:
                    -agentlib:jdwp=transport=dt_socket,address=4000,suspend=n,server=y
                (The matching agentlib string has already been placed in container_settings.json)

        Before launch:

            - Add a "Build artifacts" step.
                select dockerpipeline:jar

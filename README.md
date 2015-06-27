# Docker deployment of the AI2 Pipeline

## How to rebuild docker container:

    bash dockerbuild.sh
        . . .
        Successfully built aefd51ed88f3

## How to run a test command in the docker container:
    bash dockerrun.sh /bin/sh
        / #
    exit

## How to install intellij Docker Integration:

    The IntelliJ 14 plugin is called "Docker Integration".

    More details available:

        http://blog.jetbrains.com/idea/2015/03/docker-support-in-intellij-idea-14-1/

## How to connect intellij Docker Integration:

TODO: automate

### Part 1: Create intellij output artifact

    - Select Project Settings | Artifacts

    - Click +

    - Select JAR | from modules with dependencies

    - Fill dialog box:

        - Module: <all modules>
        - Main class: org.allenai.pipeline.examples.CountWordsAndLinesPipeline
        - JAR files from libraries: extract to the target JAR
        - Directory for META-INF/MANIFEST.MF
            change

                dockerpipeline/project
            to
                dockerpipeline/dockerbuild

### Part 2: Create run configuration

TODO

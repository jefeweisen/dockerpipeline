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
            Container settings: . . ./dockerpipeline/container_settings.json
            Debug port: 4000
                debug string will be automatically generated from port:
                    -agentlib:jdwp=transport=dt_socket,address=4000,suspend=n,server=y
                place in cmd in container_settings.json

        Before launch:

            - Add a "Build artifacts" step.
                select dockerpipeline:jar

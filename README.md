# jetbrains-backend-docker

:cd: jetbrains-backend-docker is a packaging of JetBrains IDE backends into docker containers. IDE backends from this image can be accessed via JetBrains Gateway using SSH.

## Usage
```bash
docker run -p 4222:22 bmarsaud/jetbrains-backend:ideaiu-2022.1.2
```

Choose the according image tag for the designated IDE and version of your choice. The list of availabe tags can be found on the [Docker Hub page](https://hub.docker.com/r/bmarsaud/jetbrains-backend/tags). Currently only IntelliJ Ultimate (`ideaiu`), WebStorm (`webstorm`), PhpStorm (`phpstorm`) and DataGrip (`datagrip`) are supported by this image.

Bind the SSH `22` port to an availabe port on your host.

Launch JetBrains Gateway and configure an SSH connection to your container address using a password authentication with `dev` as username and `dev` as password.

You can now choose the already installed IDE and a project folder.

### Projects
This image is not meant to contain your projects source code, I would recommand using a sidecar container containing your source code with a shared volume between the two containers.

TODO: add exemple with docker-compose

### Dependencies
This image only contains dependencies needed for the IDE to launch (+ git), you will probably need other tools like node, npm or another java version. I would recommand building your own image based on this one using the `FROM bmarsaud/jetbrains-backend:<ide>-<version>` instruction. Don't forget to start the SSH server in the entrypoint of your image using `service start ssh`.

## Build
To build the image, use the `build.sh` script with the following parameters:

|Parameter|Default value|Description|
|---|---|---|
|`-i`, `--ide`|*Required*|The IDE name (`intellij`, `idea`, `ultimate`, `webstorm`, `phpstorm`, `datagrip`)|
|`-v`, `--version`|*Required*|The IDE version (`2022.1.2`, `2021.1.3`...)|
|`-u`, `user`|`dev`|The SSH user name|
|`-p`, `--password`|`dev`|The SSH user password|
|`-i`, `--image`|`bmarsaud/jetbrains-backend`|The image name|
|`-r`, `--registry`|`registry.hub.docker.com`|The image registry onto the image will be pushed|
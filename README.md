# git-repo-banner
A small utility to produce a short text file describing the state of a git repo. Intended to
be used when producing docker images for a Kubernetes cluster, the banner created is intended 
to work well as the first part of a docker container log file.

## Demo

```bash
make test
```

## Example

Intended usage is to run it at build time of a project to produce a text file
that can be copied to a docker image to be printed at container startup.

For a python project for example

```bash
docker run -v $$(pwd):/code kodgruvan/git-repo-banner:latest "$$(hostname)" "The App Name" \
  "$$(grep __version__ main/__init__.py | head -1 | cut -d\" -f2)" America/Los_Angeles >code/.build-banner
docker build .
```

which will parse git status from the current directory (mounted at `/code`) to produce the text file `.build-banner`.

Then the container may start by printing the file, informing the user about the software version used. 

```bash
cat /code/.build-banner
```


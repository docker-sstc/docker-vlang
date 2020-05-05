# docker-vlang

Build from official release, and make sure pass `v test-compiler` all test cases.

If you wanted to make it from latest source, you could consider [taojy123/vlang](https://hub.docker.com/r/taojy123/vlang/dockerfile) or build it from [official Dockerfile](https://github.com/vlang/v/blob/master/Dockerfile)

## Usage

```sh
docker run -it --rm sstc/vlang

docker run -it --rm sstc/vlang v
```

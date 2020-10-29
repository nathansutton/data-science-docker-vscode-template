#!/bin/sh
# stop and remove the container if it is present
if [ "$(docker ps -q --filter name=stack)" ]; then
	docker rm -f stack
fi

# run the container
docker run -d \
	-p 8888:8888 -p 8787:8787\
	--mount type=bind,source="$PWD/code",destination=/code \
	--mount type=bind,source="$PWD/data",destination=/data \
	--name stack \
	--rm \
	-it stack \
	"$@"

# logs
docker logs --follow stack

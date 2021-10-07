#!/bin/sh -l
id=$(docker run -dp 3000:3000 onlinefontconverter)
docker logs --follow $id
#!/bin/bash
# Define builder and runtime images
BUILDER=docker.io/library/golang
RUNTIME=registry.access.redhat.com/ubi9/ubi-micro:latest
RELEASE=1.0.0


# Create builder container
container1=$(buildah from $BUILDER)


# Copy files from host
if [ -f go.mod ]; then 
    buildah copy $container1 'go.mod' '/go/src/hello-world/'
else
    exit 1
fi
if [ -f main.go ]; then 
    buildah copy $container1 'main.go' '/go/src/hello-world/'
else 
    exit 1
fi


# Configure and start build
buildah config --workingdir /go/src/hello-world $container1
buildah run $container1 go get -d -v ./...
buildah run $container1 go build -v ./...
# Extract build artifact and create a version archive
buildah unshare --mount mnt=$container1 \
    sh -c 'cp $mnt/go/src/hello-world/hello-world .'
cat > README << EOF
Version $RELEASE release notes:
- Implement basic features
EOF
tar zcf hello-world-${RELEASE}.tar.gz hello-world README
rm -f hello-world README


# Create runtime container
container2=$(buildah from $RUNTIME)


# Copy files from the builder container
buildah copy --chown=1001:1001 \
    --from=$container1 $container2 \
    '/go/src/hello-world/hello-world' '/'


# Configure exposed ports
buildah config --port 8080 $container2


# Configure default CMD
buildah config --cmd /hello-world $container2


# Configure default user
buildah  config--user=1001 $container2


# Commit final image
buildah commit $container2 helloworld:$RELEASE


# Remove build containers
buildah rm $container1 $container2

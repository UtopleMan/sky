# BUILD-USING:        docker build .
# RUN-USING:          docker run -p 8585:8585 -v $SKY_DATA_DIR:/var/lib/sky:rw

FROM skydb/dependencies-unstable

MAINTAINER Sky Contributors skydb.io

# Initialize environment variables.
ENV GOPATH /go
ENV GOBIN /go/bin
ENV SKYDB_PATH /go/src/github.com/skydb
ENV SKY_PATH /go/src/github.com/skydb/sky
ENV SKY_BRANCH llvm

# Update linker configuration.
RUN echo '/usr/local/lib' | tee /etc/ld.so.conf.d/sky.conf > /dev/null
RUN ldconfig

# Set up required directories.
RUN mkdir -p $GOBIN
RUN mkdir -p $SKYDB_PATH

# Download Sky to its appropriate GOPATH location.
RUN cd $SKYDB_PATH && \
    wget -O sky.tar.gz https://github.com/skydb/sky/archive/$SKY_BRANCH.tar.gz && \
    tar zxvf sky.tar.gz && \
    mv sky-$SKY_BRANCH sky && \
    cd sky

# Retrieve Sky dependencies.
RUN cd $SKY_PATH && make get

# Build and install skyd into GOBIN.
RUN cd $SKY_PATH && make build && mv skyd $GOBIN/skyd

ENTRYPOINT /go/bin/skyd -nosync=$SKY_NOSYNC -max-dbs=$SKY_MAX_DBS> -max-readers=$SKY_MAX_READERS

EXPOSE 8585

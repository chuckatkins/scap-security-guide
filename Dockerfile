FROM fedora:28

ENV OSCAP_USERNAME oscap
ENV OSCAP_DIR scap-security-guide
ENV BUILD_JOBS 4

RUN dnf -y upgrade && \
    dnf -y install cmake ninja-build openscap-utils python3-jinja2 python3-PyYAML && \
    mkdir -p /home/$OSCAP_USERNAME && \
    dnf clean all && \
    rm -rf /usr/share/doc /usr/share/doc-base \
        /usr/share/man /usr/share/locale /usr/share/zoneinfo

WORKDIR /home/$OSCAP_USERNAME

COPY . $OSCAP_DIR/

# clean the build dir in case the user is also building SSG locally
RUN rm -rf $OSCAP_DIR/build/*

WORKDIR /home/$OSCAP_USERNAME/$OSCAP_DIR/build

CMD cmake -G Ninja .. && ninja -j $BUILD_JOBS && ctest -j $BUILD_JOBS

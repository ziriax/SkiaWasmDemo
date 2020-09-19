FROM ubuntu:bionic as ubuntu
RUN apt-get update \
 && apt-get install -y apt-transport-https curl wget python git make python3

###################################################################################################

FROM ubuntu as source
RUN git clone 'https://github.com/emscripten-core/emsdk' ~/emsdk \
 && git clone 'https://skia.googlesource.com/skia.git' ~/skia \
 && git clone 'https://chromium.googlesource.com/chromium/tools/depot_tools.git' ~/depot_tools

###################################################################################################

FROM source as checkout
ENV DEPOT_TOOLS_UPDATE=0
RUN cd ~/skia \
 && git reset --hard \
 && git checkout chrome/m86 \
 && SKIA_COMMIT_DATE=$(git log -n 1 --pretty=format:%ci) \
 && cd ~/depot_tools \
 && git checkout $(git rev-list -n 1 --before="$SKIA_COMMIT_DATE" master) \
 && echo Fetching skia dependencies... \
 && cd ~/skia \
 && python2 tools/git-sync-deps

###################################################################################################

FROM checkout as build

ARG EMSCRIPTEN_VERSION=2.0.4

RUN echo Activating emsdk... \
 && cd ~/emsdk \
 && ./emsdk install ${EMSCRIPTEN_VERSION} \ 
 && ./emsdk activate ${EMSCRIPTEN_VERSION}

WORKDIR /work

COPY ./startup.sh /
RUN chmod +x /startup.sh
ENTRYPOINT [ "/startup.sh" ]


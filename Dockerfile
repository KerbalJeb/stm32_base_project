FROM ubuntu:18.04

RUN apt-get update\
    && apt-get install -y\
    cmake\
    ninja-build\
    wget\
    python\
    git

# Get the 2020q2 version of the tool chain (update the url for different version)
RUN wget -O gcc-arm-none-eabi.tar.bz2\
    https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2
# Folder to put tool-chain in
RUN mkdir gcc-arm-none-eabi
# Extract and remover original file
RUN tar xjf gcc-arm-none-eabi.tar.bz2 -C /gcc-arm-none-eabi --strip-components 1
RUN rm gcc-arm-none-eabi.tar.bz2

# add the tools to the path
ENV PATH="/gcc-arm-none-eabi/bin:${PATH}"
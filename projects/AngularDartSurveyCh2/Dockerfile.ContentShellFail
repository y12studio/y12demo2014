FROM ubuntu:13.10

# Update OS.
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade

# Install basic packages.
RUN apt-get install -y software-properties-common
RUN apt-get install -y curl git htop unzip vim wget

# Add files.
# ADD root/scripts /root/scripts

# Set environment variables.
ENV HOME /root

RUN wget http://storage.googleapis.com/dart-archive/channels/stable/release/latest/editor/darteditor-linux-x64.zip
RUN unzip -q darteditor-linux-x64.zip -d /root

ENV DART_SDK /root/dart/dart-sdk/bin
# Append to $PATH variable.
# RUN echo '\n# dart \nexport PATH="/root/dart/dart-sdk/bin:$PATH"' >> ~/.profile

# install content_shell
RUN apt-get update
RUN apt-get -y install xvfb libx11-dev libnss3 libxrandr-dev libxv-dev libxi-dev libgconf2-dev libfontconfig1-dev libglib2.0-dev libxext-dev libfreetype6-dev libxcursor-dev libxcomposite1 libasound2 libxtst6 libpangocairo-1.0-0
WORKDIR /root
RUN /root/dart/chromium/download_contentshell.sh
RUN unzip content_shell-linux-x64-release.zip -d .temp
RUN mv .temp/drt-lucid64-full-stable* $DART_SDK/content_shell

# ADD file
ADD tool /root/tool
# https://gist.github.com/dmitriy-kiriyenko/974392
RUN mv /root/tool/xvfb /etc/init.d/ && chmod 755 /etc/init.d/xvfb
ENV PATH $DART_SDK:$DART_SDK/content_shell:$PATH
CMD ["dart"]

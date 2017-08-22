############################################################
# Dockerfile to build PAC-ROMs for generating load and as PoC
# Based o nhttps://github.com/PAC-ROM/android_vendor_pac/blob/pac-5.1/docs/PrepareForBuildLinux.md
FROM ubuntu:14.04

###########################################################
# File Author / Maintainer
MAINTAINER Colinas Maoling "colinas.maoling@t-online.de"
################## BEGIN INSTALLATION ######################
ENV DEBIAN_FRONTEND "noninteractive"

RUN apt-cache search java | awk '{print($1)}' | grep -E -e '^(ia32-)?(sun|oracle)-java' -e '^openjdk-' -e '^icedtea' -e '^(default|gcj)-j(re|dk)' -e '^gcj-(.*)-j(re|dk)' -e 'java-common' | xargs sudo apt-get -y remove
RUN apt-get -y autoremove
RUN dpkg -l | grep ^rc | awk '{print($2)}' | xargs sudo apt-get -y purge
#RUN bash -c 'ls -d /home/*/.java' | xargs sudo rm -rf
#RUN rm -rf /usr/lib/jvm/*
#RUN for g in ControlPanel java java_vm javaws jcontrol jexec keytool mozilla-javaplugin.so orbd pack200 policytool rmid rmiregistry servertool tnameserv unpack200 appletviewer apt extcheck HtmlConverter idlj jar jarsigner javac javadoc javah javap jconsole jdb jhat jinfo jmap jps jrunscript jsadebugd jstack jstat jstatd native2ascii rmic schemagen serialver wsgen wsimport xjc xulrunner-1.9-javaplugin.so; do sudo update-alternatives --remove-all $g; done
RUN apt-get -y update
RUN apt-get -y install openjdk-7-jdk
RUN java -version
RUN apt-get -y install bison build-essential bzip2 curl dpkg-dev flex g++-multilib git git-review gnupg gperf lib32ncurses5-dev lib32readline-gplv2-dev lib32z1-dev libbz2-1.0 libbz2-dev libc6-dev libghc-bzlib-dev libgl1-mesa-dev libncurses5-dev libreadline6-dev libxml2-utils lzop pngcrush pngquant python-markdown schedtool squashfs-tools tofrodos x11proto-core-dev xsltproc zip zlib1g-dev
#RUN apt-get -y install libgl1-mesa-glx:i386 libreadline6-dev:i386 libx11-dev:i386 zlib1g-dev:i386
#RUN ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
RUN mkdir ~/bin && curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo && chmod a+x ~/bin/repo
RUN PATH="~/bin:$PATH"
RUN apt-get -y install phablet-tools
RUN mkdir ~/pac-rom
WORkDIR ~/pac-rom
ENV USER_EMAIL "you@example.com"
ENV USER_NAME "Your Name"
RUN git config --global user.email $USER_EMAIL
RUN git config --global user.name $USER_NAME
RUN repo init -u https://github.com/PAC-ROM/pac-rom.git -b pac-5.1 -g all,-notdefault,-darwin
RUN repo sync -j4

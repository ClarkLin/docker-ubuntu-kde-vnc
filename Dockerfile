FROM ubuntu:14.04

MAINTAINER Clark Lin "linchengkuang@foxmail.com"
ENV REFRESHED_AT 2016-03-18

ENV DEBIAN_FRONTEND noninteractive
ENV DISPLAY :1
ENV VNC_COL_DEPTH 24
ENV VNC_RESOLUTION 1280x1024
ENV VNC_PW vncpassword

############### Add Aliyun Ubuntu Mirrors ###############
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse" > /etc/apt/sources.list \
	&& echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse" >> /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list

############### xvnc / kde installation ###############
RUN apt-get update \ 
	&& apt-get upgrade -y \
	&& apt-get install -y supervisor vim kubuntu-desktop vnc4server wget unzip firefox

############### Install chrome browser ###############
RUN apt-get install -y chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg \
    && ln -s /usr/bin/chromium-browser /usr/bin/google-chrome \
    && echo "alias chromium-browser='/usr/bin/chromium-browser --user-data-dir'" >> /root/.bashrc

# xvnc server porst, if $DISPLAY=:1 port will be 5901
EXPOSE 5901
# novnc web port
EXPOSE 6901

ADD .vnc /root/.vnc
ADD .config /root/.config
ADD Desktop /root/Desktop
ADD scripts /root/scripts
RUN chmod +x /root/.vnc/xstartup /etc/X11/xinit/xinitrc /root/scripts/*.sh /root/Desktop/*.desktop

ENTRYPOINT ["/root/scripts/vnc_startup.sh"]
CMD ["--tail-log"]

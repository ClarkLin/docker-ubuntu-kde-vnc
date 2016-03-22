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
	&& apt-get install -y supervisor vim kubuntu-desktop vnc4server wget unzip firefox language-pack-zh-hans ttf-wqy-zenhei

############### Install chrome browser ###############
RUN apt-get install -y chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg \
    && ln -s /usr/bin/chromium-browser /usr/bin/google-chrome \
    && echo "alias chromium-browser='/usr/bin/chromium-browser --user-data-dir'" >> /home/vncuser/.bashrc

# xvnc server porst, if $DISPLAY=:1 port will be 5901
EXPOSE 5901
# novnc web port
EXPOSE 6901

RUN useradd vncuser
RUN mkdir /home/vncuser/
ADD .vnc /home/vncuser/.vnc
ADD .config /home/vncuser/.config
ADD Desktop /home/vncuser/Desktop
ADD scripts /home/vncuser/scripts
RUN chmod a+x /home/vncuser/.vnc/xstartup /etc/X11/xinit/xinitrc /home/vncuser/scripts/*.sh /home/vncuser/Desktop/*.desktop
RUN chown vncuser -Rf /home/vncuser

ENTRYPOINT ["/home/vncuser/scripts/vnc_startup.sh"]
CMD ["--tail-log"]

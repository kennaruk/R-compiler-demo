FROM ubuntu:latest


RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                apt-file apt-utils && apt-file update
RUN apt-get install -y --no-install-recommends --auto-remove --fix-missing \
                software-properties-common \
                ed \
                less \
                locales \
                vim-tiny \
                wget \
                curl \
                ca-certificates \
                gnupg2 \
                xterm

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
        && locale-gen en_US.utf8 \
        && /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apt-get install --no-install-recommends --auto-remove --fix-missing -y nodejs
RUN apt-get clean

ENV TZ 'Europe/London'
ENV DEBIAN_FRONTEND "noninteractive"
RUN echo $TZ > /etc/timezone \
        && apt-get update \
        && apt-get install -y tzdata \
        && rm /etc/localtime \
        && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
        && dpkg-reconfigure -f noninteractive tzdata \
        && apt-get install -y --no-install-recommends \
                r-cran-littler \
                r-base \
                r-base-dev \
                r-recommended \
                r-cran-stringr \
        && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "wget")' >> /etc/R/Rprofile.site \
        && ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
        && ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
        && ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
        && ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
        && install.r docopt \
        && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

WORKDIR /usr/src/app

COPY . .
RUN npm install
CMD ["npm", "start"]
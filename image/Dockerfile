
FROM cirepo/nix:2.0.4-bionic


ARG IMAGE_ARG_APT_MIRROR
ARG IMAGE_ARG_RUBY_VERSION


COPY --chown=ubuntu:ubuntu docker /data


RUN set -ex \
  && sudo sed -i "s/http:\/\/archive.ubuntu.com\/ubuntu\//http:\/\/${IMAGE_ARG_APT_MIRROR:-archive.ubuntu.com}\/ubuntu\//g" /etc/apt/sources.list \
  && sudo apt-get -y update \
  && echo "install tools and libs for ruby" \
  && sudo apt-get -y install gnupg2 \
  && sudo apt-get -q -y autoremove \
  && sudo apt-get -q -y clean && sudo rm -rf /tmp/* && sudo rm -rf /var/cache && sudo rm -rf /var/lib/apt && sudo rm -rf /var/log \
  && sudo mkdir -p /var/cache/apt/archives/partial && sudo mkdir -p /var/log/apt

## install global ruby
# see: https://gorails.com/setup/ubuntu/18.04
# auto installed:
# autoconf automake gawk g++ gcc make patch pkg-config
# libc6-dev libffi-dev libgdbm-dev libgmp-dev libncurses5-dev libreadline-dev libsqlite3-dev libssl-dev libyaml-dev zlib1g-dev
# bison libtool sqlite3
RUN set -ex \
  && for key in \
       409B6B1796C275462A1703113804BB82D39DC0E3 \
       7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
     ; do \
       gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
       gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
       gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
       gpg --keyserver hkp://keys.gnupg.net --recv-keys "$key" || \
       gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys "$key" ; \
     done \
  && gpg --keyserver hkp://keys.gnupg.net --recv-keys \
  && curl -L https://get.rvm.io | bash -s stable --auto-dotfiles \
  && touch ~/.bash_profile \
  && echo '[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"' >> ~/.bash_profile \
  && if [ -f /data/ruby-${IMAGE_ARG_RUBY_VERSION:-2.4.1}.tar.bz2 ]; then cp -f /data/ruby-${IMAGE_ARG_RUBY_VERSION:-2.4.1}.tar.bz2 ~/.rvm/archives/; fi \
  && ls -la ~/.rvm/archives \
  && if [ ! -f ~/.rvm/archives/ruby-${IMAGE_ARG_RUBY_VERSION:-2.4.1}.tar.bz2 ]; then ${ARIA2C_DOWNLOAD} -d ~/.rvm/archives -o ruby-${IMAGE_ARG_RUBY_VERSION:-2.4.1}.tar.bz2 https://cache.ruby-lang.org/pub/ruby/$(echo ${IMAGE_ARG_RUBY_VERSION:-2.4.1} | sed 's/\.[^.]*$//')/ruby-${IMAGE_ARG_RUBY_VERSION:-2.4.1}.tar.bz2; fi \
  && /bin/bash --login -c "rvm install ruby-${IMAGE_ARG_RUBY_VERSION:-2.4.1} && rvm use ruby-${IMAGE_ARG_RUBY_VERSION:-2.4.1} --default && ruby -v" \
  && echo "cleanup" \
  && sudo apt-get -y remove autoconf automake gawk g++ gcc make patch pkg-config \
  && sudo apt-get -y remove libc6-dev libffi-dev libgdbm-dev libgmp-dev libncurses5-dev libsqlite3-dev libssl-dev libyaml-dev zlib1g-dev \
  && sudo apt-get -y install openssl zlib1g \
  && sudo apt-get -q -y autoremove \
  && sudo apt-get -q -y clean && sudo rm -rf /tmp/* && sudo rm -rf /var/cache && sudo rm -rf /var/lib/apt && sudo rm -rf /var/log \
  && sudo mkdir -p /var/cache/apt/archives/partial && sudo mkdir -p /var/log/apt


#RUN set -ex \
#    && apt-get update -y \
#    && apt-get install -y libgdbm-dev libncurses5-dev automake libtool bison libffi-dev \
#    && for key in \
#        409B6B1796C275462A1703113804BB82D39DC0E3 \
#        7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
#      ; do \
#        gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys "$key" || \
#        gpg --keyserver hkp://keys.gnupg.net --recv-keys "$key" || \
#        gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
#        gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
#        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
#      done \
#    && gpg --keyserver hkp://keys.gnupg.net --recv-keys \
#    && curl -L https://get.rvm.io | bash -s stable --auto-dotfiles \
#    && touch ~/.bash_profile \
#    && echo '[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"' >> ~/.bash_profile \
#    && /bin/bash --login -c "rvm install ruby-${IMAGE_ARG_RUBY_VERSION:-2.4.1} && rvm use ruby-${IMAGE_ARG_RUBY_VERSION:-2.4.1} --default && ruby -v" \
#    && apt-get -q autoremove \
#    && apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

# docker-bionic-rvm-ruby

Ruby (rvm) for multi-stage docker image build.

Dockerfile [ci-and-cd/docker-bionic-rvm-ruby on Github](https://github.com/ci-and-cd/docker-bionic-rvm-ruby)

[cirepo/rvm-ruby on Docker Hub](https://hub.docker.com/r/cirepo/rvm-ruby/)

## Use this image as a “stage” in multi-stage builds

```dockerfile

FROM ubuntu:18.04
COPY --from=cirepo/rvm-ruby:2.6.1-bionic-archive /data/root /
RUN sudo chown -R $(whoami):$(id -gn) /home/$(whoami) \
  && sudo apt-get -y install autoconf automake gawk g++ gcc make patch pkg-config \
  && sudo apt-get -y install libc6-dev libffi-dev libgdbm-dev libgmp-dev libncurses5-dev libsqlite3-dev libssl-dev libyaml-dev zlib1g-dev \
  && touch /home/$(whoami)/.mkshrc \
  && echo '\
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.\
export PATH="$PATH:$HOME/.rvm/bin"\
' >> /home/$(whoami)/.mkshrc \
  && touch /home/$(whoami)/.zshrc \
  && echo '\
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.\
export PATH="$PATH:$HOME/.rvm/bin"\
' >> /home/$(whoami)/.zshrc \
  && touch /home/$(whoami)/.zlogin \
  && echo '\
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*\
' >> /home/$(whoami)/.zlogin \
  && touch /home/$(whoami)/.bashrc \
  && echo '\
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.\
export PATH="$PATH:$HOME/.rvm/bin"\
' >> /home/$(whoami)/.bashrc \
  && touch /home/$(whoami)/.profile \
  && echo '\
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.\
export PATH="$PATH:$HOME/.rvm/bin"\
\
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*\
' >> /home/$(whoami)/.profile

```

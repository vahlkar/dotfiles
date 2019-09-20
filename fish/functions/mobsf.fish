function mobsf
  /usr/bin/sudo /usr/bin/docker run -it -p 8000:8000 -v $HOME/data/mobsf:/root/.MobSF opensecurity/mobile-security-framework-mobsf:latest
end

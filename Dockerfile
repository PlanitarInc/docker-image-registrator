FROM planitar/base

ADD bin/registrator /usr/bin/

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/bin/registrator"]

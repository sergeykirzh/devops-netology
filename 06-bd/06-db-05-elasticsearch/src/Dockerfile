FROM centos:7

ARG version=7.16.0

RUN yum -y install wget \
    perl-Digest-SHA \
    && yum clean all\
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${version}-linux-x86_64.tar.gz  \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${version}-linux-x86_64.tar.gz.sha512 \
    && shasum -a 512 -c elasticsearch-${version}-linux-x86_64.tar.gz.sha512 \
    && tar -xzf elasticsearch-${version}-linux-x86_64.tar.gz \
    && rm -f elasticsearch-${version}-linux-x86_64.tar*



ENV ES_HOME=/elasticsearch-${version}

WORKDIR $ES_HOME

COPY elasticsearch.yml ./config/

RUN groupadd elasticsearch \
    && useradd -g elasticsearch elasticsearch \
    && mkdir /var/lib/logs \
    && chown elasticsearch /var/lib/logs \
    && mkdir /var/lib/data \
    && chown elasticsearch /var/lib/data \
    && mkdir ./snapshots \
    && chown -R elasticsearch ./ 
    
EXPOSE 9200 9300
   
USER elasticsearch

CMD [ "./bin/elasticsearch" ]

#CMD [ "sh", "-c", "$ES_HOME/bin/elasticsearch" ]

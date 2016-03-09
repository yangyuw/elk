FROM java:8
MAINTAINER Yumyu <yu.yang2@hpe.com>
ENV REFRESHED_AT 2016-02-29
ENV DEBIAN_FRONTEND noninteractive

ENV http_proxy=http://web-proxy.houston.hpecorp.net:8080 https_proxy=http://web-proxy.houston.hpecorp.net:8080

RUN apt-get update && \
    apt-get install --no-install-recommends -y supervisor wget curl logrotate && \
    apt-get clean
	
# Elasticsearch
RUN wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.0.deb && dpkg -i elasticsearch-1.7.0.deb

# Logstash
RUN wget https://download.elastic.co/logstash/logstash/packages/debian/logstash_2.0.0-1_all.deb && dpkg -i logstash_2.0.0-1_all.deb


# Kibana
RUN wget https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz && tar -C /opt -xvf kibana-4.1.1-linux-x64.tar.gz && ln -s /opt/kibana-4.1.1-linux-x64 /opt/kibana
EXPOSE 5601

ENV http_proxy= https_proxy=
CMD [ "/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf" ]

ADD supervisor/logstash.conf /etc/supervisor/conf.d/logstash.conf
ADD supervisor/elasticsearch.conf /etc/supervisor/conf.d/elasticsearch.conf
ADD supervisor/kibana.conf /etc/supervisor/conf.d/kibana.conf
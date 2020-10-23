# consul_wrapper

### Overview

A really simple standalone consul install cookbook. The consul service by default will be configured with:
 * client_addr 0.0.0.0
 * data_dir /opt/consul/data
 * bootstrap_expect 1
 * datacenter dc1
 * server true

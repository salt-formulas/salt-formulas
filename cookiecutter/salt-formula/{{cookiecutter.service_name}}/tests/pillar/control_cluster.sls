nova:
  controller:
    enabled: true
    networking: default
    version: liberty
    vncproxy_url: 127.0.0.1
    security_group: false
    dhcp_domain: novalocal
    scheduler_default_filters: "DifferentHostFilter,RetryFilter,AvailabilityZoneFilter,RamFilter,CoreFilter,DiskFilter,ComputeFilter,ComputeCapabilitiesFilter,ImagePropertiesFilter,ServerGroupAntiAffinityFilter,ServerGroupAffinityFilter"
    cpu_allocation_ratio: 16.0
    ram_allocation_ratio: 1.5
    bind:
      private_address: 127.0.0.1
      public_address: 127.0.0.1
      public_name: 127.0.0.1
      novncproxy_port: 6080
    database:
      engine: mysql
      host: 127.0.0.1
      port: 3306
      name: nova
      user: nova
      password: password
    identity:
      engine: keystone
      host: 127.0.0.1
      port: 35357
      user: nova
      password: password
      tenant: service
    message_queue:
      engine: rabbitmq
      host: 127.0.0.1
      port: 5672
      user: openstack
      password: password
      virtual_host: '/openstack'
      ha_queues: true
    glance:
      host: 
      port: 9292
    network:
      engine: neutron
      host: 127.0.0.1
      port: 9696
      mtu: 1500
    metadata:
      password: metadata

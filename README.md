# iod - Insights On Demand

This project creates a performance metric stack on openstack. The purpose is to create a temporarily stack to measure system performances using telegraf.

The stack uses:

* telegraf
* influxdb
* grafana

All components are completely configured, resulting with a default dashboard to monitor system performance. The IaaS used is based on openstack and requires a variables.tf, which is not included in this project.

```
variable "openstack_user_name" {
    default  = "user-name"
}

variable "openstack_tenant_name" {
    default  = "tenant-name"
}

variable "openstack_password" {
    default  = "pass-word"
}

variable "openstack_auth_url" {
    default  = "auth-url"
}

variable "openstack_keypair" {
    default  = "key-pair"
}

variable "tenant_network" {
    default  = "net-work"
}
```
Dashboard based on: https://grafana.com/dashboards/928

# Bypass IPS with packet fragmentation

This is funny project for bypass IPSs with packet fragmentation.

![Packet Fragmentation](http://uupload.ir/files/pyr9_fragment_series.png)

# Why DNS over HTTPS ?
In some countries, Internet ISPs try to use DNS Spoofing techniques to prevent access to websites that are hosted jointly and they can`t block their IP address.
That's why we try to get the actual destination address by getting through the DNS over HTTPS first and then our traffic forwarded through IPSs with Packet Fragmentation.

# Supported Linux Distro:
| Distro| Status |
|--|--|
|Ubuntu 18.04 LTS| ✅ |
| Ubuntu 16.04 LTS | ❓ |
|Kali Linux 2019.2|✅|
|Debian 9| ❓


# How to use
First set permission on script file to be executable:
```
$ chmod +x m-bipf.sh
```
then use *help*:

```
$ ./m-bipf.sh --help

Help:
	  --help , -h , help              For show help of shell script
           
          install   , --install           For installing tools and configure network
          ghost     , --ghost             same function as "install"
          uninstall , --unistall          For uninstall DNS over HTTPS software
          recovery  , --recovery          For recovery network setting to original setting
```

# catscope-validator

This guide walks you through setting up a CatScope-compatible validator, enabling real-time account graph streaming and MEV-powered trading infrastructure on Solana.

To run the system, you will need two servers, as shown in the diagram below:

* Validator Server: Runs the modified Agave validator with CatScope hooks. This server generates the real-time account graph from decoded Solana account data.

* Sidecar Server (connected via localhost or private network): Runs the sidecar, bot, and relay.
    * The **sidecar** streams live account updates from the validator and exposes them to bots via gRPC.     
    * The **relay** forwards incoming transaction requests from external clients.
    * The **bot** performs auctions and sorts winning transactions by proportion for submission based on MEV opportunity.(i.e. highest bidders received greater transactions per sec)

All components are installed as daemonized processes using **systemd.**

![Validator Network Diagram](network-1.png)

# Table of Contents
1. [Prerequisites](#prerequisites)  
2. [System Requirements](#system-requirements) 
3. [Install CatScope Debian Packages](#install-catscope-debian-packages)  
4. [Validator Server Setup](validator-setup.md)  
5. [Sidecar Server Setup](sidecar-setup.md)  
6. [Bot and Relay Setup](start-pipeline.md)


## Prerequisites

```
sudo apt update && sudo ??????????
```

To run a CatScope Validator, you will need:
* 2 servers:
    * One for the Validator
    * One for the CatScope Sidecar and marketplace processes 
* A private network connection or firewall between the two machines to ensure secure communication.

## System Requirements

| Role      | CPU         | RAM        | Disk     |
|-----------|-------------|------------|----------|
| Validator | 32+ cores | - GB | - |
| Sidecar   | 20+ cores   | - GB     | - |

## Install CatScope Debian Packages

Download and install the following Debian packages (`.deb`) on the appropriate machines:

### On the **Validator Server**:
- `catscope-validator`: A fork of Agave validator with support for CatScope hooks.
- `catscope-geyser`: Enables real-time read access for streaming graph data.
- `solpipe-filter`: The default edge generator, which supports the graph creation of marketplace users. 

```cli
apt-get install blah
```
### On the **Sidecar Server**:
- `catscope-sidecar`: A gRPC service that streams and receives validator data in real time.

```cli
apt-get install blah
```
> You can verify install success with:
> ```cli
> ls -la /usr/bin/catscope-grpc-server
> ls -la /usr/bin/agave-validator
> ```




> Need help? Contact us:
https://catscope.io/contact/
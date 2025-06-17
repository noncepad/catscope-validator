# catscope-validator

This guide walks you through setting up a CatScope-compatible validator, enabling real-time account graph streaming and MEV-powered trading infrastructure on Solana.

## Prerequisites

To run a CatScope Validator, you will need:
* 2 servers:
    * One for the validator
    * One for the CatScope sidecar
* A private network connection or firewall between the two machines to ensure secure communication.

## Step 1: Install Required Packages

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
---

## Step 2: Start the Validator

is this systemd thing to start the validator commonly how those start the agave validator ??


Follow the full debug guide here: [Start Validator](start-validator.md)

## Step 3: Start the Side Car

## Step 4:  List Your Validator on CatScope

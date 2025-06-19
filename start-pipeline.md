# Running a Pipeline
To create a pipeline you will need to configure two integral components: a “bot” and a “relay”. The bot assumes the role of creating and overseeing the pipeline, while the relay is responsible for the communication between the bidders and pipelines.

Once your pipeline is activated, bidders can submit bids for a share of the Validator read/write bandwidth, securing a proportion based on the strength of their bid.

## Overview

To create and run a pipeline, you’ll configure two critical components:
- **Bot**: Creates and manages the pipeline, runs per-slot auctions.
- **Relay**: Forwards incoming bid requests to the bot for processing.

These are launched as `systemd` services after setup. Once active, your pipeline will begin accepting bids, selling access to your bandwidth through continuous on-chain auctions.

## Install Marketplace Binaries
Install solpipe and safejar CLI tools on the sidecar server:

```bash
wget -O /usr/local/bin/solpipe https://github.com/noncepad/solpipe-terminal/releases/latest/download/solpipe
wget -O /usr/local/bin/safejar https://github.com/noncepad/solpipe-terminal/releases/latest/download/safejar
chmod +x /usr/local/bin/solpipe /usr/local/bin/safejar
```

Make sure they're available in your `$PATH`.

## Initialize A Pipeline

To create a pipeline, you must first define **who controls the treasury (vault)** for fee payments and earnings. This is done using [SafeJar](https://safejar.io/), a treasury management system built for bot workflows.

### Step 1 — Create a Jar + Delegation Account (Vault Owner)
Before launching a pipeline, you'll need a **SafeJar Delegation Account** that acts as the owner of your vault.

You can either:

- **(Coming Soon)** Auto-generate a default jar + delegation during pipeline init using the `--create-jar` flag  
- **(Recommended for now)** Create your own vault and delegation manually using the SafeJar CLI

> Full guide: [SafeJar Jar & Delegation Setup](https://safejar.io/docs/jar/)

### Step 2 — Pick Your Marketplace Type

There are currently two supported CatScope marketplace types, with a third in development:


| Type   | Description                                 | Marketplace ID           |
|--------|---------------------------------------------|--------------------------|
| Read   | Monetize validator read access (graph data) | `<READ_MARKETPLACE_ID>` |
| Write  | Monetize transaction processing (txproc)    | `<WRITE_MARKETPLACE_ID>`|
| Bot    | **Coming Soon** — Deploy bots directly inside the validator      | *(Under testing)*          |


To monetize **both**, initialize one pipeline per type and daemonize a **bot + relay** for each.


### Step 3 — Initialize a Pipeline with `solpipe`

Use the `solpipe pipeline init` command to generate your config files:

```bash
mkdir my-pipeline
cd my-pipeline
solpipe pipeline init <marketplace_id> . \
  --vault-owner <delegation_id_pubkey> \
```
> Full guide: [Solpipe Pipeline Init Docs](https://solpipe.io/docs/pipeline/)

**What This Command Does**
It creates a pipeline configuration folder with the following files:
* bot.json: defines auction logic, fee budget, and on-chain behavior
* relay.json: handles external requests
* authorizer.json: signs bot transactions

### Step 4 — Configure the Bot and Create the Pipeline Onchain

Your `bot.json` defines the auction logic, fee strategy, and on-chain behavior of your pipeline.

Here's an example of what a valid `bot.json` might look like:

```json
{
  "Controller": "2WoJTtRWoNzKJXfsQKuu9qvFLiqLwmSueHU9zX1hBeZC",
  "Authorizer": "7tDYAe1MM5fFVZiFersbQpVMCxJHaCZXJ3sUrEZgui5L",
  "VaultOwner": "8DSMXaitmG3sepxb4iaHTUhesstPcvTZV6sWpxXi5vSH",
  "TickSize": 1,
  "ScoopDelay": 1,
  "RefundSpace": 10,
  "BidSpace": 10,
  "PeriodLength": 1500,
  "MaxAuctionLength": 6000,
  "MaxPayoutCount": 0
}

You’ll want to customize parameters like `TickSize`, `PeriodLength`, `BidSpace`, and `MaxAuctionLength` to suit your strategy and available resources.

> For a full explanation of each field and how to tune your pipeline:
https://solpipe.io/docs/pipeline/bot/


Once you're happy with your config, register the pipeline with the bot.json:
```bash
solpipe pipeline create ./bot.json

```
### Step 5 — Configure the Relay 

Your `relay.json` defines how external bidders connect to your pipeline and how traffic is routed internally to the validator-side services.

Here’s an example `relay.json`:

```json
{
  "non_bidder": false,
  "authorizer": "7tDYAe1MM5fFVZiFersbQpVMCxJHaCZXJ3sUrEZgui5L",
  "pipeline": "5jjfRxSLWXvUsTu2UGBeH4nZt7tphYo1WEm3PxN9xy1p",
  "backends": [
    {
      "services": ["txproc.TransactionProcessing"],
      "address": "tcp://127.0.0.1:30000"
    }
  ],
  "endpoints": [
    {
      "routable": [
        "tcp://[2405:6580:840:9100:6fcc:d5c0:fdcf:ee61]:40000"
      ],
      "listen": "tcp://:40000"
    }
  ],
  "usagelua": "/etc/catscope/market/usage.lua",
  "window": "30m"
}
Explanation:
backends.address: Must connect locally to the sidecar (use 127.0.0.1 or Unix domain socket)

endpoints.listen: What IP/port the relay listens on (bind to :PORT)

endpoints.routable: Public IP or IPv6 of your validator (same port as listen)

usagelua: Path to the Lua script defining usage billing logic

> Need help? Contact us:
https://catscope.io/contact/
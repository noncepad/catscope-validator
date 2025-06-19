# Running a Pipeline
To create a pipeline you will need to configure two integral components: a “bot” and a “relay”. The bot assumes the role of creating and overseeing the pipeline, while the relay is responsible for the communication between the bidders and pipelines.
These are launched as `systemd` services after setup. Once active, your pipeline will begin accepting bids, selling access to your read/write bandwidth through continuous on-chain auctions.



## Install Solpipe Marketplace Binaries
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
Before launching a pipeline, you'll need a **SafeJar Delegation Account** that acts as the owner of your pipeline's vault.

You can either:
- **(Coming Soon)** Auto-generate a default jar + delegation during pipeline init using the `--create-jar` flag  
- **(Recommended for now)** Create your own vault and delegation manually using the SafeJar CLI

> Follow instructions here: [SafeJar Jar & Delegation Setup](https://safejar.io/docs/jar/)

### Step 2 — Marketplace Type

There are currently two supported CatScope marketplace types, with a third in development:


| Type   | Description                                 | Marketplace ID           |
|--------|---------------------------------------------|--------------------------|
| Read   | Monetize validator read access (graph data) | `<READ_MARKETPLACE_ID>` |
| Write  | Monetize transaction processing (txproc)    | `<WRITE_MARKETPLACE_ID>`|
| Bot    | **Coming Soon** — Deploy bots directly inside the validator      | *(Under testing)*          |


To monetize **both**, initialize one pipeline per type and daemonize a **bot + relay** for each.


### Step 3 — Initialize and Create your Pipeline Onchain.

> Full guide: [Solpipe Pipeline Docs](https://solpipe.io/docs/pipeline/)

After you’ve finished the `init` and `create` commands, confirm your pipeline exists on-chain by running (fetch pipeline-id from create output):
```bash
solpipe view pipeline --pipeline-id <your_pipeline_id>
solpipe view account <your_pipeline_id>
```
You can also search for the pipeline ID directly on [Solana Explorer](https://explorer.solana.com/).

If the account exists and shows valid data, you're ready to move on to daemonizing both the bot and relay.


## Daemonize the Bot and Relay with systemd

After verifying your pipeline exists on-chain, you can run your **bot** and **relay** as persistent background services using `systemd`.

### Example: Relay systemd Unit File
Create the following file at ```/etc/systemd/system/catscope-relay.service```:
```bash
[Unit]
Description=Catscope gRPC Server Read Pipeline
After=network.target tor.service

[Service]
ExecStart=/usr/bin/solpipe pipeline -v relay /etc/catscope/pipeline/write/relay.json $FEE_PAYER
Restart=always
RestartSec=180
User=solpipe
Group=solpipe
WorkingDirectory=/var/share/catscope/astralane-pipeline/write
EnvironmentFile=/etc/default/astralane-pipeline

[Install]
WantedBy=multi-user.target
```
> Make sure your EnvironmentFile defines `FEE_PAYER`, `STATE_URL`, and `TXPROC_URL`.
> * `FEE_PAYER` — the path to your `authorizer.json` file    
>   Make sure the file is readable:
>   ```bash
>   chmod 600 /path/to/authorizer.json
>   ```
> * `STATE_URL` and `TXPROC_URL` — the read and write endpoints of your **own validator**. These should point to the `catscope-sidecar` services connected to your validator node.


### Don’t Forget the Bot
Repeat the same process for the bot. Create a similar unit file (e.g. /etc/systemd/system/catscope-bot.service) and point it to pipeline bot with the same environment setup.



> Need help? Contact us:
https://catscope.io/contact/


# Shooter

This is a local utility to grab low latency updates from the validator.

## Download Source Code

```bash
mkdir catscope-buffer
cd catscope-buffer
git remote add origin https://git.noncepad.com/catscope-buffer.git
git fetch origin
git checkout 0.2.0
```

Compile a producer and consumer.

```bash
cargo build --release
```

The binaries `consumer` and `producer` will be in the `target/release` directory.

## producer

The `/etc/catscope/geyser.json` file sets the shared memory buffer publishing endpoints for the shooter producer:

```json
    "shooter":{
      "broadcast_path":"/validator",
      "version":1,
      "buffer_size":1000000
    },
```

Run the publisher with this command:

```bash
./publisher tcp://0.0.0.0:47324  /validator /v
```

* `tcp://0.0.0.0:47324` - this is the zeromq listening port
* `/validator` - this is the shared memory buffer address
* `/v` - this is the zeromq topic on which updates are published

## consumer

The consumer subscribes to zeromq endpoint of the publisher and pushes updates to a local shared memory buffer.

TBD.

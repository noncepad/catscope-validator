#!/bin/bash

exec /usr/bin/agave-validator \
  --identity /home/sol/validator.json \
  --vote-account 5Y7DLnF3HDC2JygZuWypypFfLxkmVLaAuc9TSAd6jhYi \
  --ledger /mnt/ledger \
  --accounts /mnt/accounts \
  --rpc-port 8899 \
  --no-port-check \
  --dynamic-port-range 8000-8020 \
  --entrypoint entrypoint.testnet.solana.com:8001 \
  --entrypoint entrypoint2.testnet.solana.com:8001 \
  --entrypoint entrypoint3.testnet.solana.com:8001 \
  --expected-genesis-hash 4uhcVJyU9pJkvQyS88uRDiswHXSCkY3zQawwpjk2NsNY \
  --wal-recovery-mode skip_any_corrupted_record \
  --known-validator 5D1fNXzvv5NjV1ysLjirC4WY92RNsVH18vjmcszZd8on \
  --geyser-plugin-config /etc/catscope/geyser.json \
  --limit-ledger-size

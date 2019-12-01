# [TiKV](https://github.com/tikv/tikv) build environment

## Usage

Clone TiKV repository

Put the shell.nix under the tikv directory

``` shell
nix-shell shell.nix
```

## Known issues

* `make clippy` would fail for [gRPC](https://github.com/tikv/grpc-rs) which complains `PROTOBUF_ROOT_DIR` and `GFLAGS_ROOT_DIR` is wrong.
* `make audit` would fail due to the SSL certificate invalid issue.

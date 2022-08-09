# Ignite



### Scaffold a chain

```bash
ignite scaffold chain github.com/username/planet
```

The `github.com` URL in the argument is a string that is used for the Go module path. 



### Directory structure

- `app`: files that wire the blockchain together
- `cmd`: binary for the blockchain node
- `docs`: static `openapi.yml` API doc for the blockchain node
- `proto`: protocol buffer files for custom modules
- `x`: modules
- `vue`: scaffolded web application (optional)
- `config.yml`: configuration file



### Common commands

```shell
spidexd keys export alice --unarmored-hex --unsafe // 输出私钥
spidexd tx bank send alice spdx1ueze0pwan3943g008myytfemvka00grtz3qjdy 1000000000000aspx --gas-prices 0.01aspx --gas-adjustment 1.5 --gas=auto -y // 打钱
hermes keys list band-laozi-testnet5 // 查看地址
hermes health-check // 启动relayer之前跑这个
```



### Bug

```javascript
// 1. Reason: gRPC call failed with status: status: Unknown, message: "transport error", details: [], metadata: MetadataMap { headers: {} }
// 关闭代理

// 2. 
```


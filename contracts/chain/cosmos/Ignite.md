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

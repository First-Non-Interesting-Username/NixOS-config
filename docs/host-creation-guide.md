# Host creation guide

## Steps

### (Outsiders only) Fork this repo

Fork this repo. You can do that with github webui or `gh` CLI tool:

```bash
gh repo fork First-Non-Interesting-Username/NixOS-config
```

It might be a good idea to let me know that you are a user of this config, so I can provide assistance to you and ship less breaking changes.

### Choose a base host and a hostname

Select a host you want to base your host on and a name for your host.

Naming hosts and a few host names I came up with are available in [host-names.md](/docs/host-names.md) doc.

You should base your host on the `template` host, unless your host is very similiar to another, existising host.

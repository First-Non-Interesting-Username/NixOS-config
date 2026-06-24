# Special args

## Table of Contents

- [Special args](#special-args)
  - [`custom.user`](#customuser)
  - [`hostname`](#hostname)
  - [`gitName` & `gitEmail`](#gitname--gitemail)
  - [`width` & `height`](#width--height)
  - [`impermanence`](#impermanence)

## `custom.user`

The `custom.user` module option replaces the old `username` special arg.
Set it in your host configuration:

```nix
custom.user = {
  enable = true;
  name = "your-username";
};
```

Import `nixosModules.user` to enable the user module.

## `hostname`

This special arg is your hostname.
You MUST use it, because it's also used to set the name of the host.
Import `nixosModules.networking-*` to actually set it as the hostname.

## `gitName` & `gitEmail`

Those set your git email and git name.
The value of `gitEmail` might be used in other modules, where email is needed.

## `width` & `height`

They set the size of the wallpaper in px.
(yes, that's it)
You can omit them if you want, this way the generated wallpaper will be generated in 1080p.

## `impermanence`

This special arg will enable impermanence when set to true.
You have to import `nixosModules.impermanence` for it to work.
All the files you may want to persist, will be automatically added by each module you import.

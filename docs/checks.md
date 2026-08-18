# Checks

Checks (also called tests) are deriviations built by nix to check things.

In this flake, I currently only have VM tests.

## Philosphy of writing checks

I write checks only in 2 cases:

- I suspect something might break in a way other check/building flake won't catch it
- Something broke without me knowing in advance/upstream issue

Then I create a test for that thing.

I trust upstream (in particular nixpkgs) to not break things and have checks on their own.

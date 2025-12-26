
This is my first time using Nix & NixOS.
I have absolutely no idea what I'm doing, so there's definitely some extremely stupid stuff here.

`sudo nixos-rebuild switch --upgrade -L --flake .#nixos --option eval-cache false`

Use after system is fine for a few days just incase:
`sudo nix-garbage-collect -d`

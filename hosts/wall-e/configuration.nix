{lib, ...}: {
  users.users.root = {
    initialPassword = "nixos";
    hashedPassword = lib.mkForce null;
  };
}

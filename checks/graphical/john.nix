{
  self,
  inputs,
  ...
}: let
  Hostname = "john";
in {
  perSystem = {pkgs, ...}: {
    checks.${Hostname} = pkgs.testers.runNixOSTest {
      name = Hostname;

      nodes.${Hostname} = {
        imports = self.nixosConfigurations.${Hostname}._module.args.modules;
      };

      node.specialArgs = {
        inherit self inputs Hostname;
      };

      testScript = ''
        ${Hostname}.wait_for_unit("multi-user.target")
        ${Hostname}.succeed("hostname | grep ${Hostname}")
        ${Hostname}.wait_for_unit("graphical.target")
        ${Hostname}.wait_for_unit("display-manager.service")
      '';
    };
  };
}

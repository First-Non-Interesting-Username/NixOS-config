inputs: {
  lib,
  config,
  ...
}: {
  config =
    lib.mkIf (config ? sops)
    && lib.mkIf config.custom.shell.enable {
      sops.secrets."HACK_CLUB_AI_API_KEY" = {
        owner = config.custom.user.name;
      };

      home-manager.users.${config.custom.user.name} = {osConfig, ...}: {
        imports = [
          inputs.hack.homeManagerModules.default
        ];
        programs.hack = {
          enable = true;
          settings = {
            base_url = "https://ai.hackclub.com/proxy/v1";
            model = "deepseek/deepseek-v4-pro";
            api_key_path = osConfig.sops.secrets.HACK_CLUB_AI_API_KEY.path;
          };
        };
      };
    };
}

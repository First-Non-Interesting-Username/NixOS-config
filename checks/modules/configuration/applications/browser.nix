{self, ...}: {
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    checkname = "browser";
    username = "testuser";
    uid = "1000";
  in {
    checks = lib.optionalAttrs (system == "x86_64-linux") {
      ${checkname} = pkgs.testers.runNixOSTest {
        name = checkname;
        requiredFeatures.kvm = pkgs.stdenv.hostPlatform.isx86_64;
        nodes.machine = {...}: {
          imports = [
            self.nixosModules.browser
            self.nixosModules.user
            self.nixosModules.preservation
            self.nixosModules.home-manager
            self.nixosModules.stylix
          ];

          custom = {
            user = {
              enable = true;
              name = username;
              password = username;
            };
            stylix.enable = false;
          };
          hardware.graphics.enable = true;

          virtualisation.memorySize = 4096;
          virtualisation.resolution = {
            x = 1280;
            y = 800;
          };

          environment.etc."firefox-test.html".text = ''
            <!doctype html>
            <html>
            <head><meta charset="utf-8"><title>Firefox Test</title></head>
            <body style="background:white;color:black;margin:0;display:flex;align-items:center;justify-content:center;height:100vh;font-family:DejaVu Sans,sans-serif">
              <div style="text-align:center">
                <h1 style="font-size:72px;line-height:1;margin:0">Firefox Test OK</h1>
                <p style="font-size:32px;margin:16px 0 0 0">Welcome Mozilla</p>
                <p style="font-size:24px;opacity:0.8">Offline Check Passed 123</p>
              </div>
            </body>
            </html>
          '';

          systemd.tmpfiles.rules = [
            "C /tmp/test.html 0644 root root - /etc/firefox-test.html"
          ];

          fonts.packages = with pkgs; [dejavu_fonts];

          home-manager.users.${username} = _: {
            programs.bash.enable = true;
          };

          users.users.${username}.extraGroups = ["video" "render"];

          services.cage = {
            enable = true;
            user = username;
            program = let
              cageFirefox = pkgs.writeShellScript "cage-firefox" ''
                export HOME=/home/${username}
                export XDG_RUNTIME_DIR=/run/user/${uid}
                export MOZ_ENABLE_WAYLAND=1
                export WLR_RENDERER_ALLOW_SOFTWARE=1
                export LIBGL_ALWAYS_SOFTWARE=1
                export GALLIUM_DRIVER=llvmpipe
                export MOZ_DISABLE_CONTENT_SANDBOX=1
                export MOZ_DISABLE_GMP_SANDBOX=1
                export MOZ_DISABLE_RDD_SANDBOX=1
                export MOZ_DISABLE_SOCKET_PROCESS_SANDBOX=1
                sleep 1
                exec ${pkgs.firefox}/bin/firefox --kiosk "file:///etc/firefox-test.html" --no-remote
              '';
            in "${cageFirefox}";
          };
        };

        enableOCR = true;

        testScript = {nodes, ...}: ''
          machine.wait_for_unit("multi-user.target")
          machine.wait_for_unit("home-manager-${username}.service")
          machine.wait_for_unit("cage-tty1.service")
          machine.succeed("su - ${username} -c 'command -v firefox'")
          machine.succeed("su - ${username} -c 'grep -q \"text/html=firefox.desktop\" ~/.config/mimeapps.list'")
          machine.succeed("su - ${username} -c 'grep -q \"x-scheme-handler/https=firefox.desktop\" ~/.config/mimeapps.list'")
          machine.succeed("su - ${username} -c 'grep -q firefox <<< \"$BROWSER\"'")
          machine.succeed("su - ${username} -c 'grep -q firefox <<< \"$DEFAULT_BROWSER\"'")
          machine.succeed("cat /etc/firefox-test.html | grep -q 'Firefox Test OK'")
          machine.succeed("ls -l /etc/firefox-test.html /tmp/test.html || true")
          machine.wait_for_file("/run/user/${uid}/wayland-0")
          machine.wait_until_succeeds("pgrep -f firefox", timeout=120)
          machine.sleep(10)
          machine.screenshot("01_cage_started")
          try:
              machine.wait_for_text("Firefox Test", timeout=60)
          except Exception as e:
              machine.log(machine.succeed("systemctl status cage-tty1 --no-pager || true"))
              machine.log(machine.succeed("journalctl -u cage-tty1 --no-pager --lines 300 || true"))
              machine.log(machine.succeed("journalctl --no-pager _COMM=firefox --lines 300 || true"))
              machine.log(machine.succeed("ps aux || true"))
              machine.log(machine.succeed("cat /etc/firefox-test.html || true"))
              machine.screenshot("99_failure")
              raise e
          machine.succeed("grep -q 'Welcome Mozilla' /etc/firefox-test.html")
        '';
      };
    };
  };
}

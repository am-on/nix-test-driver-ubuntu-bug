{
  description = "Nix test-driver ubuntu bug demo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-vm-test.url = "github:numtide/nix-vm-test";
  };

  outputs = { self, nixpkgs, nix-vm-test }: {

    packages.x86_64-linux.test-vm =
      let
        vmTest = nix-vm-test.lib.x86_64-linux.ubuntu."23_10" {
          sharedDirs = {};
          testScript = ''
            vm.wait_for_unit("multi-user.target")
            vm.execute("sudo bash -c \"echo 'Created foo → bar.\n' >&2 && echo 'foo' \"")
          '';
        };
        in vmTest.driverInteractive;

    packages.x86_64-linux.default = self.packages.x86_64-linux.test-vm;

  };
}

let
  dev-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcax4Fmk6ON9o37dRAHexB9QNQml8SByYg/s5yTB+/G dev-server-host-key";
in
{
  "secrets/addison-password.age".publicKeys = [ dev-server ];
  "secrets/client-key.age".publicKeys = [ dev-server ];
}

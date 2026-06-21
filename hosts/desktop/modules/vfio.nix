{ pkgs, username, ... }:

{
  users.users.${username}.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];

    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
    ];
  };

  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
}

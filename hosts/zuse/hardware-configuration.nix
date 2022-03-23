# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = let kernelPackage = pkgs.linuxPackages_latest;
  in {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices."luks".device = "/dev/nvme0n1p2";
    };

    loader = {
      grub = {
        enable = true;
	version = 2;
	enableCryptodisk = true;
	efiSupport = true;
	useOSProber = true;
 	device = "nodev";	
      };
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = kernelPackage;
    kernelModules = [ "kvm-amd" "amdgpu" ];
    extraModulePackages = with kernelPackage; [ acpi_call ];

    extraModprobeConfig = ''
    options iwlmvm power_scheme=1
    '';

    resumeDevice = "/dev/disk/by-label/SWAP";

    enableContainers = true;

  };

  hardware = {
    cpu.amd.updateMicrocode = true;

    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl rocm-opencl-icd ];
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "btrfs";
    options = [ "defaults" "discard=async" "compress-force=zstd" "subvol=@" ];
  };
  fileSystems."/root" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "btrfs";
    options = [ "defaults" "discard=async" "compress-force=zstd" "subvol=@root" ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "btrfs";
    options = [ "defaults" "discard=async" "compress-force=zstd" "subvol=@nix" ];
  };
  fileSystems."/etc" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "btrfs";
    options = [ "defaults" "discard=async" "compress-force=zstd" "subvol=@etc" ];
  };
  fileSystems."/var/log" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "btrfs";
    options = [ "defaults" "discard=async" "compress-force=zstd" "subvol=@log" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "btrfs";
    options = [ "defaults" "discard=async" "compress-force=zstd" "nosuid" "nodev" "subvol=@home" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
    options = [ "defaults" "nosuid" "noexec" "nodev" ];
  };

  swapDevices = [{
    device = "/dev/disk/by-label/SWAP";
  }];

}

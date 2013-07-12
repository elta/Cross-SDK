#ifndef CROSSPROJECTMANAGERCONSTANTS_H
#define CROSSPROJECTMANAGERCONSTANTS_H

namespace CrossProjectManager {
namespace Constants {

const char ACTION_ID[] = "CrossProjectManager.Action";
const char MENU_ID[] = "CrossProjectManager.Menu";

// Target Abis
const char DESKTOP_TARGET_ABI[] = "CrossProjectManager.TargetABI.ABI";
const char RADIO_BUTTON_ABI[] = "CrossProjectManager.RadioButton.ABI";

enum {
    CROSS_PROJECT_TARGET_ABI_WORDWIDTH_32 = 32,
    CROSS_PROJECT_TARGET_ABI_WORDWIDTH_64 = 64
};

//settings:
const char CROSS_SETTINGS_CATEGORY[]="Cross Project Manager";
const char CROSS_SETTINGS_ID[]="CROSS.SETTINGS.ID";

// Toolchains:

const char CROSSLINUX_TOOLCHAIN_32BIT_TYPE[] = "CrossLinux.ToolChain.32Bit.Type";
const char CROSSLINUX_TOOLCHAIN_32BIT_DISPLAYNAME[] = "Cross Linux 32 Bit Compiler";
const char CROSSLINUX_TOOLCHAIN_32BIT_ID[] = "CrossProjectManager.ToolChain.CROSSLINUX32Bit";

const char CROSSLINUX_TOOLCHAIN_64BIT_TYPE[] = "CrossLinux.ToolChain.64Bit.Type";
const char CROSSLINUX_TOOLCHAIN_64BIT_DISPLAYNAME[] = "Cross Linux 64 Bit Compiler";
const char CROSSLINUX_TOOLCHAIN_64BIT_ID[] = "CrossProjectManager.ToolChain.CROSSLINUX64Bit";

//run build deploy Configuration
const char CROSS_RUN_CONFIGURATION[] = "CrossProjectManager.Run.Configuration";
const char CROSS_DEPLOY_CONFIGURATION[] = "CrossProjectManager.DEPLOY.Configuration";
const char CROSS_DEPLOY_STEP_ID[] ="CrossProjectManager.DEPLOY.STEP.ID";


//kit
const char CROSS_KIT_ID[] = "CrossProjectManager.KIT.CROSS";

//devices
const char CROSS_DEVICE_32_BIT_TYPE[] = "Cross.Device.32.Bit.Type";
const char CROSS_DEVICE_64_BIT_TYPE[] = "Cross.Device.64.Bit.Type";
const char CROSS_DEVICE_32_BIT_ID[] = "Cross.Device.32BIT";
const char CROSS_DEVICE_64_BIT_ID[] = "Cross.Device.64BIT";
const char QEMU_64BIT_HOST_IP[] ="10.0.0.64";
const char QEMU_32BIT_HOST_IP[] ="10.0.0.32";

//Actions
const char QEMU_ACTION_ID[] ="CrossProjectManager.QEMU.ACTION.ID";
const char MOUNT_ACTION_ID[] ="CrossProjectManager.MOUNT.ACTION.ID";
const char UNMOUNT_ACTION_ID[] ="CrossProjectManager.UNMOUNT.ACTION.ID";

//icons
const char QEMU_RUN_ICON[]=":/res/icon/qemu-run.png";
const char QEMU_STOP_ICON[]=":/res/icon/qemu-stop.png";
const char CROSS_SETTINGS_ICON[]=":/res/icon/book.png";

//mkspec

const char MKSPEC_MIPS64EL_O32[]="mips64el-o32-gnu";
const char MKSPEC_MIPS64EL_N32[]="mips64el-n32-gnu";
const char MKSPEC_MIPS64EL_N64[]="mips64el-n64-gnu";
const char MKSPEC_MIPSEL_O32[]="mipsel-o32-gnu";




} // namespace CrossProjectManager
} // namespace Constants

#endif // CROSSPROJECTMANAGERCONSTANTS_H


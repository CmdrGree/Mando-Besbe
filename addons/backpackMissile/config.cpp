#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        author = AUTHOR;
        authors[] = {"CmdrGree"};
        url = ECSTRING(main,url);
        name = COMPONENT_NAME;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "mndb_main",
            "mndb_common"
        };
        units[] = {};
        weapons[] = {QGVAR(backpack_missile_item)};
        VERSION_CONFIG;
    };
};

class CfgAmmo
{
    class R_MRAAWS_HE_F;
    class GVAR(backpack_missile): R_MRAAWS_HE_F
    {
        displaname = "Backpack Missile";
        model = QPATHTOF(missiles\backpackMissile.p3d);
    };
};


class CfgWeapons {
    class ItemCore;
    class InventoryItem_Base_F;
    class GVAR(backpack_missile_item): ItemCore
    {
        displayName = "Backpack Missile";
        author = "CmdrGree";
        model = QPATHTOF(missiles\backpackMissile.p3d);
        scope = 2;
        scopeCurator = 2;
        descriptionShort = "A powerful missile.";
        simulation = "ItemMineDetector";
        ACE_isUnique = 1;

        class ItemInfo: InventoryItem_Base_F
        {
            picture = "";
            inertia = 0.5;
        };
    };
};

class UserActionGroups {
    class GVAR(Keybinds) {
        name = "Mando Besbe Backpack Missile"; // Display name of your category.
        isAddon = 1;
        group[] = { QGVAR(ToggleTargeting), QGVAR(Launch), QGVAR(NextMode), QGVAR(PrevMode), QGVAR(NextTarget), QGVAR(PrevTarget), QGVAR(Reload) }; // List of all actions inside this category.
    };
};

class CfgUserActions {
    class GVAR(ToggleTargeting) {
        displayName = "Toggle Targeting";
        tooltip = "This action toggles backpack missile targeting.";
        onActivate = QUOTE(0 call FUNC(activate));        // _this is always true.
        onDeactivate = "";        // _this is always false.
    };
    class GVAR(Launch) {
        displayName = "Launch Missile";
        tooltip = "This action launches your backpack missile.";
        onActivate = QUOTE(0 call FUNC(launch));        // _this is always true.
        onDeactivate = "";        // _this is always false.
    };
    class GVAR(NextMode) {
        displayName = "Next Targeting Mode";
        tooltip = "This action selects the next backpack missile targeting mode.";
        onActivate = QUOTE(0 call FUNC(next_mode));        // _this is always true.
        onDeactivate = "";        // _this is always false.
    };
    class GVAR(PrevMode) {
        displayName = "Previous Targeting Mode";
        tooltip = "This action selects the previous backpack missile targeting mode.";
        onActivate = QUOTE(0 call FUNC(previous_mode));        // _this is always true.
        onDeactivate = "";        // _this is always false.
    };
    class GVAR(NextTarget) {
        displayName = "Select Next Target";
        tooltip = "This action selects the next backpack missile target.";
        onActivate = QUOTE(0 call FUNC(next_target));        // _this is always true.
        onDeactivate = "";        // _this is always false.
    };
    class GVAR(PrevTarget) {
        displayName = "Select Previous Target";
        tooltip = "This action selects the previous backpack missile target.";
        onActivate = QUOTE(0 call FUNC(previous_target));        // _this is always true.
        onDeactivate = "";        // _this is always false.
    };
    class GVAR(Reload) {
        displayName = "Reload Backpack Missile";
        tooltip = "This action reloads the backpack missilte.";
        onActivate = QUOTE(0 call FUNC(reload));        // _this is always true.
        onDeactivate = "";        // _this is always false.
    };
};

class CfgSounds {
    class GVAR(LaunchSound1) {
        name = "Backpack Missile Launch Sound 1";                        // display name
        sound[] = { QPATHTOF(sounds\missile_launch_1.ogg), 1, 1, 1000 };    // file, volume, pitch, maxDistance
        titles[] = {0, ""};
    };
    class GVAR(LaunchSound2) {
        name = "Backpack Missile Launch Sound 2";                        // display name
        sound[] = { QPATHTOF(sounds\missile_launch_2.ogg), 1, 1, 1000 };    // file, volume, pitch, maxDistance
        titles[] = {0, ""};
    };
    class GVAR(LaunchSound3) {
        name = "Backpack Missile Launch Sound 3";                        // display name
        sound[] = { QPATHTOF(sounds\missile_launch_3.ogg), 1, 1, 1000 };    // file, volume, pitch, maxDistance
        titles[] = {0, ""};
    };
    class GVAR(LockOnSound) {
        name = "Backpack Missile Lock On Sound";                        // display name
        sound[] = { QPATHTOF(sounds\lock_on.ogg), 1, 1, 1000 };    // file, volume, pitch, maxDistance
        titles[] = {0, ""};
    };
    class GVAR(SelectModeSound) {
        name = "Backpack Missile Select Mode Sound";                        // display name
        sound[] = { QPATHTOF(sounds\select_mode.ogg), 1, 1, 1000 };    // file, volume, pitch, maxDistance
        titles[] = {0, ""};
    };
    class GVAR(ClickSound) {
        name = "Backpack Missile Click Sound";                        // display name
        sound[] = { QPATHTOF(sounds\click.ogg), 1, 1, 1000 };    // file, volume, pitch, maxDistance
        titles[] = {0, ""};
    };
    class GVAR(ClickBeepSound) {
        name = "Backpack Missile Click Beep Sound";                        // display name
        sound[] = { QPATHTOF(sounds\click_beep.ogg), 1, 1, 1000 };    // file, volume, pitch, maxDistance
        titles[] = {0, ""};
    };
};

#include "CfgEventHandlers.hpp"
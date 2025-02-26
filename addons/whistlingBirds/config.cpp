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
        units[] = {QGVAR(whistlingbird)};
        weapons[] = {QGVAR(whistlingbird_item)};
        VERSION_CONFIG;
    };
};

class CfgVehicles {
    class Land_Baseball_01_F;
    class ThingX;
    class GVAR(whistlingbird): ThingX
    {
        scope = 2;
        scopeCurator = 2;
        editorCategory = QEGVAR(Common,Props);
        editorSubcategory = "EdSubcat_Default";
        destrType = "DestrctNo";
        displayname = "Whistling Bird";
        model = QPATHTOF(birds\whistlingbird.p3d);
        //description = "micro rocket designed for mandalorian gauntlet";
        simulation = "thingX";
        ace_dragging_canCarry = 1;
        ace_dragging_carryPosition[] = {0, 1, 0};
        ace_dragging_carryDirection = 0;
    };
};

class CfgWeapons {
    class ItemCore;
    class InventoryItem_Base_F;
    class GVAR(whistlingbird_item): ItemCore
    {
        displayName = "Whistling Bird";
        author = "Shoya Haa'runi";
        model = QPATHTOF(birds\whistlingbird.p3d);
        scope = 2;
        scopeCurator = 2;
        descriptionShort = "Made from beskar. Use them sparingly, unless you want to extract them from your enemies.";
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
        name = "Mando Besbe Whistling Birds"; // Display name of your category.
        isAddon = 1;
        group[] = { QGVAR(ToggleTargeting), QGVAR(Launch), QGVAR(MoreTargets), QGVAR(FewerTargets) }; // List of all actions inside this category.
    };
};

class CfgUserActions {
    class GVAR(ToggleTargeting) {
        displayName = "Toggle Targeting";
        tooltip = "This action toggles whistling birds targeting.";
        onActivate = QUOTE(_this call FUNC(activate));        // _this is always true.
        onDeactivate = "";        // _this is always false.
    };
    class GVAR(Launch) {
        displayName = "Launch Whistling Birds";
        tooltip = "This action launches your whistling birds at your targets.";
        onActivate = QUOTE(_this call FUNC(launch_birds));        // _this is always true.
        onDeactivate = "";        // _this is always false.
    };
    class GVAR(MoreTargets) {
        displayName = "Increase Number Of Targets";
        tooltip = "This action increases the number of selected targets.";
        onActivate = QUOTE(_this call FUNC(more_targets));        // _this is always true.
        onDeactivate = "";        // _this is always false.
    };
    class GVAR(FewerTargets) {
        displayName = "Decrease Number Of Targets";
        tooltip = "This action decreases the number of selected targets.";
        onActivate = QUOTE(_this call FUNC(fewer_targets));        // _this is always true.
        onDeactivate = "";        // _this is always false.
    };
};

class CfgSounds {
    class GVAR(ActivateSound) {
        name = "Whistling Birds Activate";                        // display name
        sound[] = { QPATHTOF(sounds\wbActivate.ogg), 1, 1, 10 };    // file, volume, pitch, maxDistance
        titles[] = {0, ""};
    };
    class GVAR(LaunchSound) {
        name = "Whistling Birds Launch";                        // display name
        sound[] = { QPATHTOF(sounds\wbLaunch.ogg), 1, 1, 20 };    // file, volume, pitch, maxDistance
        titles[] = {0, ""};
    };
    class GVAR(HitSound1) {
        name = "Whistling Birds Hit 1";                        // display name
        sound[] = { QPATHTOF(sounds\wbHit1.ogg), 1, 1, 20 };    // file, volume, pitch, maxDistance
        titles[] = {0, ""};
    };
    class GVAR(HitSound2) {
        name = "Whistling Birds Hit 2";                        // display name
        sound[] = { QPATHTOF(sounds\wbHit2.ogg), 1, 1, 20 };    // file, volume, pitch, maxDistance
        titles[] = {0, ""};
    };
    class GVAR(HitSound3) {
        name = "Whistling Birds Hit 3";                        // display name
        sound[] = { QPATHTOF(sounds\wbHit3.ogg), 1, 1, 20 };    // file, volume, pitch, maxDistance
        titles[] = {0, ""};
    };
};

#include "CfgEventHandlers.hpp"
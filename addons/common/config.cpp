#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        author = AUTHOR;
        authors[] = {"CmdrGree"};
        url = ECSTRING(main,url);
        name = COMPONENT_NAME;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "mndb_main"
        };
        units[] = {QGVAR(whistlingbird)};
        weapons[] = {QGVAR(whistlingbird_item)};
        VERSION_CONFIG;
    };
};

class CfgEditorCategories
{
    class GVAR(Props)
    {
        displayName = "Mando-Besbe Props";
    };
};


class CfgVehicles {
    class Land_Baseball_01_F;
    class GVAR(whistlingbird): Land_Baseball_01_F
    {
        scope = 2;
        scopeCurator = 2;
        editorCategory = QGVAR(Props);
        editorSubcategory = "EdSubcat_Default";
        destrType = "DestrctNo";
        displayname = "Whistling Bird";
        model = QPATHTOF(birds\whistlingbird.p3d);
        description = "micro rocket designed for mandalorian gauntlet";
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

#include "CfgEventHandlers.hpp"
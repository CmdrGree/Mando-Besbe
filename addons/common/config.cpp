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
        units[] = {};
        weapons[] = {};
        VERSION_CONFIG;
    };
};

class CfgEditorCategories {
    class GVAR(Props)
    {
        displayName = "Mando-Besbe Props";
    };
};

#include "CfgEventHandlers.hpp"
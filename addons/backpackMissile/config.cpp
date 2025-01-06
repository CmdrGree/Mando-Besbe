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
        weapons[] = {};
        VERSION_CONFIG;
    };
};

class UserActionGroups {
	class ModSection {
		name = "Mando Besbe Backpack Missile"; // Display name of your category.
		isAddon = 1;
		group[] = { QGVAR(EnableTargeting), QGVAR(Launch), QGVAR(NextMode), QGVAR(PrevMode), QGVAR(NextTarget), QGVAR(PrevTarget) }; // List of all actions inside this category.
	};
};

class CfgUserActions {
    class GVAR(EnableTargeting) {
        displayName = "Enable Targeting";
		tooltip = "This action enables backpack missile targeting.";
		onActivate = "";		// _this is always true.
		onDeactivate = "";		// _this is always false.
    };
    class GVAR(Launch) {
        displayName = "Launch Missile";
		tooltip = "This action launches your backpack missile.";
		onActivate = "";		// _this is always true.
		onDeactivate = "";		// _this is always false.
    };
    class GVAR(NextMode) {
        displayName = "Next Targeting Mode";
		tooltip = "This action selects the next backpack missile targeting mode.";
		onActivate = "";		// _this is always true.
		onDeactivate = "";		// _this is always false.
    };
    class GVAR(PrevMode) {
        displayName = "Enable Targeting";
		tooltip = "This action selects the previous backpack missile targeting mode.";
		onActivate = "";		// _this is always true.
		onDeactivate = "";		// _this is always false.
    };
    class GVAR(NextTarget) {
        displayName = "Launch Missile";
		tooltip = "This action selects the next backpack missile target.";
		onActivate = "";		// _this is always true.
		onDeactivate = "";		// _this is always false.
    };
    class GVAR(PrevTarget) {
        displayName = "Launch Missile";
		tooltip = "This action selects the previous backpack missile target.";
		onActivate = "";		// _this is always true.
		onDeactivate = "";		// _this is always false.
    };
};

#include "CfgEventHandlers.hpp"
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
	class GVAR(Keybinds) {
		name = "Mando Besbe Backpack Missile"; // Display name of your category.
		isAddon = 1;
		group[] = { QGVAR(ToggleTargeting), QGVAR(Launch), QGVAR(NextMode), QGVAR(PrevMode), QGVAR(NextTarget), QGVAR(PrevTarget) }; // List of all actions inside this category.
	};
};

class CfgUserActions {
    class GVAR(ToggleTargeting) {
        displayName = "Toggle Targeting";
		tooltip = "This action toggles backpack missile targeting.";
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
        displayName = "Previous Targeting Mode";
		tooltip = "This action selects the previous backpack missile targeting mode.";
		onActivate = "";		// _this is always true.
		onDeactivate = "";		// _this is always false.
    };
    class GVAR(NextTarget) {
        displayName = "Select Next Target";
		tooltip = "This action selects the next backpack missile target.";
		onActivate = "";		// _this is always true.
		onDeactivate = "";		// _this is always false.
    };
    class GVAR(PrevTarget) {
        displayName = "Select Previous Target";
		tooltip = "This action selects the previous backpack missile target.";
		onActivate = "";		// _this is always true.
		onDeactivate = "";		// _this is always false.
    };
};

#include "CfgEventHandlers.hpp"
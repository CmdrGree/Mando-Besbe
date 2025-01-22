#include "..\script_component.hpp"
/*
     * Author: You!
     * An empty function that does nothing.
     *
     * Arguments:
     * None
     *
     * Return Value:
     * None
     *
     * Example:
     * [] call mndb_addonName_fnc_empty;
     *
     * Public: No
*/
private _targeting = player getVariable ["BackpackMissileTargeting", false];
private _missileLoaded = player getVariable ["BackpackMissileLoaded", true];
private _targeting_mode = player getVariable["BackpackMissileTargetingMode", "direct"];
if (_missileLoaded) then {
    player say3D QGVAR(ClickSound);
    if (_targeting) then {
        player setVariable ["BackpackMissileTargeting", false];
        systemChat "Deactivating Missile Targeting";
    } else {
        player setVariable ["BackpackMissileTargeting", true];
        systemChat "Activating Missile Targeting";

        switch (_targeting_mode) do {
            case "on screen": {
                player spawn FUNC(on_screen_targeting);
            };
        };
    };
} else {
    systemChat "No backpack missile loaded."
};
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
private _targetingMode = player getVariable ["BackpackMissileTargetingMode", "direct"];
if (_targeting) then {
	switch (_targetingMode) do {
		case "on screen": {
			[player getVariable "targetVehicle", true] spawn FUNC(jetpack_missile);
		};
		case "direct": {
			_target = 0 call FUNC(get_target);
			_target spawn FUNC(jetpack_missile);
		};
		case "direct with offset": {
			_target = 0 call FUNC(get_target_and_offset);
			_target spawn FUNC(jetpack_missile);
		};
	};
	player setVariable ["BackpackMissileTargeting", false];
};
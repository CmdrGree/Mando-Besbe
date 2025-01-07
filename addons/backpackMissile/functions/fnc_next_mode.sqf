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
private _modes = ["direct", "direct with offset", "on screen"];
private _targeting = player getVariable ["BackpackMissileTargeting", false];
if (_targeting) then {
	private _targeting_mode = player getVariable["BackpackMissileTargetingMode", "direct"];
	private _mode_number = _modes find _targeting_mode;
	player setVariable ["BackpackMissileTargetingMode", _modes select ((_mode_number + 1) % (count _modes))];
	systemChat format ["Switching to %1 targeting mode", player getVariable "BackpackMissileTargetingMode"];
};
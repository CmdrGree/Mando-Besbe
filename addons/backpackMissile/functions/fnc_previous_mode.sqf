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
	if (_mode_number == 0) then {
		_mode_number = count _modes;
	};
	player setVariable ["BackpackMissileTargetingMode", _modes select ((_mode_number - 1))];

	private _mode = player getVariable ["BackpackMissileTargetingMode", "direct"];
	if (_mode == "on screen") then {
		player spawn FUNC(on_screen_targeting);
	};
	systemChat format ["Switching to %1 targeting mode", _mode];
};
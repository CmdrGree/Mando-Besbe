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
params ["_range", "_player", "_highlight"];
player setVariable ["selectedTarget", 0];
systemChat str (player getVariable "selectedTarget");
_targets = [_range, _player] call getUnitsOnScreenArc;
player setVariable ["numTargets", count _targets];
systemChat str _targets;
while { player getVariable ["_targeting", false] } do {
	_selectedTarget = player getVariable "selectedTarget";
	{
		if (_forEachIndex == _selectedTarget % count _targets) then {
			drawIcon3D["\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa", _highlight, getPos _x, 1, 1, 0, "", 0];
			player setVariable ["targetVehicle", _x];
		} else {
			drawIcon3D["\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa", [1, 1, 1, 1], getPos _x, 1, 1, 0, "", 0];
		};
	} forEach _targets;

	sleep 0.01;
};
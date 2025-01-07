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
if (_targeting) then {
	_selectedTarget = player getVariable ["selectedTarget", 0];
	if (_selectedTarget == 0) then {
		_selectedTarget = player getVariable "numTargets";
	};
	player setVariable ["selectedTarget", _selectedTarget - 1];
	systemChat format ["Selected Target %1", player getVariable "selectedTarget"];
	player say3D QGVAR(ClickSound);
};
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
	player setVariable ["selectedTarget", (_selectedTarget + 1) % (player getVariable "numTargets")];
	systemChat format ["Selected Target %1", player getVariable "selectedTarget"];
};
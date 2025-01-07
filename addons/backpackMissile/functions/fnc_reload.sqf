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
if (!_targeting && !_missileLoaded) then {
	player setVariable ["BackpackMissileLoaded", true];
};
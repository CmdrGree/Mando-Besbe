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
_targeting = player getVariable ["WhistlingBirdsTargeting", false];
if (_targeting) then {
	_numTargets = player getVariable ["numTargets", 12];
	if (_numTargets < (uniqueUnitItems player) getOrDefault [QGVAR(whistlingbird_item), 0]) then {
		player setVariable ["numTargets", _numTargets + 1];
	};
};
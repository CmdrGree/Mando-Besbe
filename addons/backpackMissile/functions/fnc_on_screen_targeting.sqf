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
_range = profileNamespace getVariable["BackpackMissileRange", 2000];
_highlight = profileNamespace getVariable["BackpackMissileHighlightColor", [1, 0, 0, 1]];
player setVariable ["selectedTarget", 0];
_targets = [_range, player] call FUNC(get_units_on_screen);
player setVariable ["numTargets", count _targets];
player setVariable ["BackpackMissileTargets", _targets];
systemChat str _targets;

addMissionEventHandler ["Draw3D", {
	_thisArgs params ["_targets", "_highlight"];
	if (player getVariable["BackpackMissileTargeting", false] && player getVariable["BackpackMissileTargetingMode", "direct"] == "on screen") then {
		_selectedTarget = player getVariable ["selectedTarget", 0];
		{
			if (_forEachIndex == _selectedTarget % count _targets) then {
				drawIcon3D["a3\ui_f\data\map\groupicons\selector_selectedenemy_ca.paa", _highlight, ASLToAGL (aimPos _x), 1, 1, 0, "", 0];
			} else {
				drawIcon3D["a3\ui_f\data\map\groupicons\selector_selectable_ca.paa", [1, 1, 1, 1], ASLToAGL (aimPos _x), 1, 1, 0, "", 0];
			};
		} forEach _targets;
	} else {
		removeMissionEventHandler ["Draw3D", _thisEventHandler];
	}
}, [_targets, _highlight]];
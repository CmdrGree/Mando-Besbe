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
addUserActionEventHandler ["User11", "Activate", {
	player setVariable ["_targeting", true];
	[2000, player, [1, 0, 0, 1]] spawn targetingFunction;
	removeUserActionEventHandler ["User11", "Activate", _thisEventHandler];

	_nextEvent = addUserActionEventHandler ["User8", "Activate", {
		_selectedTarget = player getVariable "selectedTarget";
		player setVariable ["selectedTarget", (_selectedTarget + 1) % (player getVariable "numTargets")];
		systemChat format ["Selected Target %1", player getVariable "selectedTarget"];
	}];
	_previousEvent = addUserActionEventHandler ["User9", "Activate", {
		_selectedTarget = player getVariable "selectedTarget";
		if (_selectedTarget == 0) then {
			_selectedTarget = player getVariable "numTargets"
		};
		player setVariable ["selectedTarget", _selectedTarget - 1];
		systemChat format ["Selected Target %1", player getVariable "selectedTarget"];
	}];

	player setVariable ["selectNextTargetEventID", _nextEvent];
	player setVariable ["selectPreviousTargetEventID", _previousEvent];

	systemChat "Activate Targeting!";

	addUserActionEventHandler["defaultAction", "Activate", {
		player setVariable ["_targeting", false];
		removeUserActionEventHandler ["defaultAction", "Activate", _thisEventHandler];
		removeUserActionEventHandler ["User8", "Activate", player getVariable "selectNextTargetEventID"];
		removeUserActionEventHandler ["User9", "Activate", player getVariable "selectPreviousTargetEventID"];
		systemChat "Launch!";
		[player getVariable "targetVehicle", true] spawn missileFunction;
	}];
}];

player setVariable ["_count", 1];
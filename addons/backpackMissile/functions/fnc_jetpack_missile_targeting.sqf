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
addUserActionEventHandler["defaultAction", "Activate", {
	if (player getVariable ["_count", 1] > 0) then {
		_target = 0 call FUNC(get_target);
		if ((player getVariable "_count") -1 <= 0) then {
			removeUserActionEventHandler["defaultAction", "Activate", _thisEventHandler]
		};
		_target spawn missileFunction;
	} else {
		removeUserActionEventHandler["defaultAction", "Activate", _thisEventHandler];
	};
}];
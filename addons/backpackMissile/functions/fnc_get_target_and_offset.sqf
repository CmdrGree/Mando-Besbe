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
_raycast = (lineIntersectsSurfaces[AGLToASL positionCameraToWorld [0, 0, 0], AGLToASL positionCameraToWorld [0, 0, 1000], player, objNull, true, 1, "FIRE"]) select 0;
_target = _raycast select 0;
_offset =[];
_isVehicle = false;
if (_raycast select 2 isKindOf "AllVehicles") then {
	_offset = (_raycast select 2) worldToModel(_raycast select 0);
	_target = _raycast select 2;
	_isVehicle = true;
};
[_target, _isVehicle, _offset];
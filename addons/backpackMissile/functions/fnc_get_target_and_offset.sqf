#include "..\script_component.hpp"
/*
	 * Author: CmdrGree
	 * Gets a target and hit offset.
	 *
	 * Arguments:
	 * None
	 *
	 * Return Value:
	 * Array - [target, isVehicle, offset]
	 *
	 * Example:
	 * [] call FUNC(get_target_and_offset);
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
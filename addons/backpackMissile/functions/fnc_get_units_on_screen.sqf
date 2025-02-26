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
params ["_range", "_player"];
_units = _player nearEntities["AllVehicles", _range];
_onScreen = [];
{
    if (alive _x) then {
        _screenPos = worldToScreen position _x;
        if (count _screenPos > 0) then {
            _onScreen pushBack _x;
        };
    };
} forEach _units;

_onScreen = _onScreen select {
    !(_x isKindOf "Man")
};
_onScreen;
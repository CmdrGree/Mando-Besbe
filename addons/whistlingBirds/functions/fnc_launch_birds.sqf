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
    player getVariable ["whistlingBirdsTargets", []] spawn {
        params ["_targets"];
        player say3D [QGVAR(ActivateSound)];
        _numTargets = player getVariable ["numTargets", 12];
        {
            if (_forEachIndex < _numTargets) then {
                [_x, profileNamespace getVariable "_leftieBirds", profileNamespace getVariable "_lethalBirds", _forEachIndex] spawn FUNC(whistling_birds);
                player removeItem QGVAR(whistlingbird_item);
                if (_forEachIndex % 3 == 0) then {
                    player spawn {
                        _soundSource = '#particlesource' createVehicle getPos (_this);
                        _soundSource say3D [QGVAR(LaunchSound), 0];
                        sleep 1.2;
                        deleteVehicle _soundSource;
                    };
                };
                sleep 0.1;
            }
        } forEach _targets;

        private _drawEH = player getVariable ["birdsTargetPainter", -1];
        if (_drawEH >= 0) then {
            removeMissionEventHandler ["Draw3D", _drawEH];
        };
        player setVariable ["WhistlingBirdsTargeting", false];
    };
};
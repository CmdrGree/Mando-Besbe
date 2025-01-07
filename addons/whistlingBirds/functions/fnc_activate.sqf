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
	player setVariable ["WhistlingBirdsTargeting", false];
	private _drawEH = player getVariable ["birdsTargetPainter", -1];
	if (_drawEH >= 0) then {
		removeMissionEventHandler ["Draw3D", _drawEH];
	};
} else {
	private _maxBirds = 12;
	private _numBirds = (uniqueUnitItems player) getOrDefault [QGVAR(whistlingbird_item), 0];
	if (_numBirds > _maxBirds) then {
		_numOver = _numBirds - _maxBirds;
		systemChat format ["You can only carry %1 whistling birds! Removing %2", _maxBirds, _numOver];
		for "_i" from 0 to _numOver-1 do {
			player removeItem QGVAR(whistlingbird_item);
		};
		_numBirds = (uniqueUnitItems player) getOrDefault [QGVAR(whistlingbird_item), 0];
	};
	if (_numBirds == 0) exitWith {
		removeUserActionEventHandler ["User11", "Activate", _thisEventHandler];
		systemChat "Out of whistling birds.";
	};

	// find targets
	private _units = (getPos player) nearEntities ["man", 40];
	private _targets = [];
	{
		if ((side _x) getFriend (side player) < 0.6) then {
			_targets pushBack _x;
		};
	} forEach _units;

	// Limit default number of targets selected by how many whistling birds you have.
	if (player getVariable ["numTargets", 12] > _numBirds) then {
		player setVariable ["numTargets", _numBirds];
	};
	systemChat format ["You have %1 out of %2 whistling birds.", _numBirds, _maxBirds];

	// Limit default number of targets selected by how many targets there are.
	if (count _targets > player getVariable ["numTargets", 12]) then {
		player setVariable ["numTargets", count _targets];
	};

	if (_numBirds > 0) then {
		if ((count _targets) > 0) then {
			player say3D [QGVAR(ActivateSound), 0];

			// sort _targets by distance from player.
			_targets = _targets apply {
				[_x distance player, _x];
			};
			_targets sort false;
			_targets = _targets apply {
				_x select 1
			};
			reverse _targets;

			_targets = _targets select [0, _maxBirds];

			_targetPainter = addMissionEventHandler["Draw3D", {
				_numTargets = player getVariable ["numTargets", 12];
				_targets = _thisArgs select 0;
				{
					if (_forEachIndex < _numTargets) then {
						drawIcon3D["a3\ui_f\data\map\groupicons\selector_selectable_ca.paa", [1, 1, 1, 1], ASLToAGL aimPos _x, 1, 1, 0, "", 0];
					};
				} forEach _targets;
			}, [_targets]];

			player setVariable ["whistlingBirdsTargets", [_targets]];
			player setVariable ["birdsTargetPainter", _targetPainter];
			player setVariable ["WhistlingBirdsTargeting", true];
		};
	} else {};
};
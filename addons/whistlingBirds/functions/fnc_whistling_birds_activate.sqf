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
_eh = addUserActionEventHandler ["User11", "Activate", {
	_targeting = player getVariable ["WhistlingBirdsTargeting", false];
	_maxBirds = 12;
	_numBirds = (uniqueUnitItems player) getOrDefault [QGVAR(whistlingbird_item), 0];
	if (_numBirds > _maxBirds) then {
		_numOver = _numBirds - _maxBirds;
		systemChat format ["%1 is too many whistling birds! Removing %2", _numBirds, _numOver];
		for "_i" from 0 to _numOver-1 do {
			player removeItem QGVAR(whistlingbird_item);
		};
		_numBirds = (uniqueUnitItems player) getOrDefault [QGVAR(whistlingbird_item), 0];
	};
	if (_numBirds == 0) exitWith {
		removeUserActionEventHandler ["User11", "Activate", _thisEventHandler];
		systemChat "Out of whistling birds.";
	};

	_numTargets = player getVariable ["numTargets", 12];
	if (_numTargets > _numBirds) then {
		player setVariable ["numTargets", _numBirds];
	};
	systemChat format ["You have %1 out of %2 whistling birds.", _numBirds, _maxBirds];

	_units = (getPos player) nearEntities ["man", 40];
	_targets = [];
	{
		if ((side _x) getFriend (side player) < 0.6) then {
			_targets pushBack _x;
		};
	} forEach _units;
	if (!_targeting && _numBirds > 0) then {
		if ((count _targets) > 0) then {
			playSound3D [getMissionPath "\sfx\wbActivate.ogg", player];

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

			_moreTargetsHandler = addUserActionEventHandler["User8", "Activate", {
				_numTargets = player getVariable ["numTargets", 12];
				if (_numTargets < (uniqueUnitItems player) getOrDefault [QGVAR(whistlingbird_item), 0]) then {
					player setVariable ["numTargets", _numTargets + 1]
				};
			}];

			_fewerTargetsHandler = addUserActionEventHandler["User9", "Activate", {
				_numTargets = player getVariable ["numTargets", 12];
				if (_numTargets > 1) then {
					player setVariable ["numTargets", _numTargets - 1];
				};
			}];

			_targetPainter = addMissionEventHandler["Draw3D", {
				_numTargets = player getVariable ["numTargets", 12];
				_targets = _thisArgs select 0;
				{
					if (_forEachIndex < _numTargets) then {
						drawIcon3D["\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa", [1, 1, 1, 1], ASLToAGL aimPos _x, 1, 1, 0, "", 0];
					};
				} forEach _targets;
			}, [_targets]];

			_fireHandler = addUserActionEventHandler ["defaultAction", "activate", {
				player getVariable "whistlingBirdsTargets" spawn {
					params ["_targets"];
					player say3D [QGVAR(ActivateSound)];
					_numTargets = player getVariable ["numTargets", 12];
					{
						if (_forEachIndex < _numTargets) then {
							[_x, profileNamespace getVariable "_leftieBirds", profileNamespace getVariable "_lethalBirds"] spawn FUNC(whistling_birds);
							player removeItem QGVAR(whistlingbird_item);
							if (_forEachIndex % 3 == 0) then {
								player say3D [QGVAR(LaunchSound), 0];
							};
							sleep 0.1;
						}
					} forEach _targets;
					_handlers = player getVariable "birdsEventHandlers";
					removeMissionEventHandler ["Draw3D", _handlers select 0];
					removeUserActionEventHandler ["User8", "Activate", _handlers select 1];
					removeUserActionEventHandler ["User9", "Activate", _handlers select 2];
					removeUserActionEventHandler ["defaultAction", "Activate", _handlers select 3];
					// removeUserActionEventHandler ["User11", "Activate", _handlers select 4];
					player setVariable ["WhistlingBirdsTargeting", false];
				};
			}];

			player setVariable ["whistlingBirdsTargets", [_targets]];
			player setVariable ["birdsEventHandlers", [_targetPainter, _moreTargetsHandler, _fewerTargetsHandler, _fireHandler, _thisEventHandler]];
			player setVariable ["WhistlingBirdsTargeting", true];
		};
	} else {
		_handlers = player getVariable "birdsEventHandlers";
		removeMissionEventHandler ["Draw3D", _handlers select 0];
		removeUserActionEventHandler ["User8", "Activate", _handlers select 1];
		removeUserActionEventHandler ["User9", "Activate", _handlers select 2];
		removeUserActionEventHandler ["defaultAction", "Activate", _handlers select 3];
		// removeUserActionEventHandler ["User11", "Activate", _handlers select 4];
		player setVariable ["WhistlingBirdsTargeting", false];
	};
}];
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
params ["_target", ["_isVehicle", false], ["_offset", []]];
if (! isNil "_target") then {
	player say3D QGVAR(ClickBeepSound);
	player setVariable ["BackpackMissileTargeting", false];
	player setVariable ["BackpackMissileLoaded", false];

	_missile = createVehicle [QGVAR(backpack_missile), (getPosATL player) vectorAdd [0, 0, 0], [], 0, "CAN_COLLIDE"];
	   // attach position changed to more closely align with backpack
	_missile attachTo [player, [0, -0.02, 0.5], "spine3"];
	// _missile setVectorDirAndUp (player selectionVectorDirAndUp ["spine3", "Memory"]);
	detach _missile;

	// Missile orientation based on neck offset from model base
	_pitchBank = _missile call BIS_fnc_getPitchBank;
	_positionHead = player selectionPosition ["neck", "Memory"];
	if (_positionHead select 1 <= 0.4) then {
		[_missile, (_pitchBank select 0) + 45, 0] call BIS_fnc_setPitchBank;
		if (_positionHead select 1 <= 0.25) then {
			[_missile, (_pitchBank select 0) + 75, 0] call BIS_fnc_setPitchBank;
			if (_positionHead select 1 < 0) then {
				[_missile, (_pitchBank select 0) + 120, 0] call BIS_fnc_setPitchBank;
			}
		};
	} else {
		[_missile, (_pitchBank select 0) + 15, 0] call BIS_fnc_setPitchBank;
	};
	   // speed inverted from -20 to +20, added to player velocity to avoid jumping up into missile
	_missile setVelocityModelSpace[0, (((velocityModelSpace player) select 1) + 20), 0];

	_timeAlive = 0;
	_lifetime = 4;
	_vehicleDamage = 0.5;
	_time_step = 0.02;
	_thrust = 2; // Missile thrust (N)
	_mass = getMass _missile; // Missile mass (kg)
	if (_mass == 0) then {
		_mass = 0.01
	};
	_maxTurnRate = 30; // max turn rate (rad/s)

	private _launchSounds = [QGVAR(LaunchSound1), QGVAR(LaunchSound2), QGVAR(LaunchSound3)];
	private _soundSource = '#particlesource' createVehicle getPos (_missile);
	    // added missile smoke effect so it's not naked anymore
	_soundSource setParticleClass "Flare2";
	_soundSource attachTo [_missile, [0, 0, 0], "Exhaust"];
	_soundSource say3D [selectRandom _launchSounds, 10000, 1, 0, 0, true];

	_drawEH = addMissionEventHandler ["Draw3D", {
		_thisArgs params ["_missile", "_target", "_isVehicle", "_offset"];

		if (_isVehicle) then {
			private _targetPos = aimPos _target;
			if (count _offset == 3) then {
				_targetPos vectorAdd _offset;
			};
			drawLine3D [getPos _missile, ASLToAGL _targetPos, [1, 1, 1, 1]];
			drawIcon3D["a3\ui_f\data\map\groupicons\selector_selectedenemy_ca.paa", [1, 1, 1, 1], ASLToAGL _targetPos, 1, 1, 0, "", 0];
		} else {
			drawLine3D [getPos _missile, ASLToAGL _target, [1, 1, 1, 1]];
			drawIcon3D["a3\ui_f\data\map\groupicons\selector_selectedenemy_ca.paa", [1, 1, 1, 1], ASLToAGL _target, 1, 1, 0, "", 0];
		};
	}, [_missile, _target, _isVehicle, _offset]];

	while { alive _missile && _timeAlive < _lifetime } do {
		private _distance_to_target = [_target, _missile, _mass, _thrust, _maxTurnRate, _isVehicle, _time_step, true, true, _offset] call EFUNC(common,guidance_step);
		// Lifetime step.
		_timeAlive = _timeAlive + _time_step;
		sleep _time_step;
	};
	removeMissionEventHandler ["Draw3D", _drawEH];
	deleteVehicle _missile;
	sleep ((_target distance player) / 340.29);
	deleteVehicle _soundSource;
};
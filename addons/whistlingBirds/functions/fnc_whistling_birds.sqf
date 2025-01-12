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
params ["_target", ["_leftie", true], ["_isLethal", true]];
if (! isNil "_target") then {
	_missile = createVehicle [QGVAR(whistlingbird), player modelToWorld (player selectionPosition "leftforearmroll" vectorAdd [0, 0, 0]), [], 0, "CAN_COLLIDE"];
	// _missile = createVehicle ["Land_Baseball_01_F", player modelToWorld (player selectionPosition "leftforearmroll" vectorAdd [0, 0, 0]), [], 0, "CAN_COLLIDE"];
	if (_leftie) then {
		_handOrientation = player selectionVectorDirAndUp ["leftforearmroll", "Memory"];
		_missile setVectorDirAndUp [player vectorModelToWorldVisual _handOrientation #0, player vectorModelToWorldVisual _handOrientation #1];
		_missile setVelocityModelSpace[-7, 0, -7];
	} else {
		_missile setPos (player modelToWorld (player selectionPosition "rightforearmroll" vectorAdd [0, 0, 0]));
		_handOrientation = player selectionVectorDirAndUp ["rightforearmroll", "Memory"];
		_missile setVectorDirAndUp [player vectorModelToWorldVisual _handOrientation #0, player vectorModelToWorldVisual _handOrientation #1];
		_missile setVelocityModelSpace[5, 0, -5];
	};

	// _missile  = createVehicle ["Land_Tableware_01_fork_F", player modelToWorld (player selectionPosition "lefthand"), [], 0, "CAN_COLLIDE"];

	_drawEH = addMissionEventHandler ["Draw3D", {
		drawIcon3D["a3\ui_f\data\map\groupicons\selector_selectedenemy_ca.paa", [1, 1, 1, 1], ASLToAGL aimPos (_thisArgs select 0), 1, 1, 0, "", 0];
	}, [_target]];

	_timeAlive = 0;
	_lifetime = 4;

	_time_step = 0.02;
	_thrust = 20; // Missile thrust (N)
	_mass = getMass _missile; // Missile mass (kg)
	if (_mass == 0) then {
		_mass = 0.01
	};
	_maxTurnRate = 60; // max turn rate (rad/s)

	// Particle Effects
	_source = '#particlesource' createVehicle (getPosASL _missile);
	_source setParticleClass "Flare2";
	_source attachTo [_missile, [0, 0, 0]];

	while { _timeAlive < _lifetime } do {
		_distance_to_target = [_target, _missile, _mass, _thrust, _maxTurnRate, true, _time_step, false, false, []] call EFUNC(common,guidance_step);
		// Check if missile has hit.
		if (_distance_to_target <= 0.5) then {
			if (_isLethal) then {
				_target setDamage 1
			} else {
				_target spawn {
					_this setUnconscious true;
					sleep 3;
					_this setUnconscious false;
				}
			};
			break;
		};
		// Lifetime step.
		_timeAlive = _timeAlive + _time_step;
		sleep _time_step;
	};
	_hitSounds = [QGVAR(HitSound1), QGVAR(HitSound2), QGVAR(HitSound3)];
	[_missile, _hitSounds] spawn {
		_soundSource = '#particlesource' createVehicle getPos (_this select 0);
		_soundSource say3D [selectRandom (_this select 1), 0];
		sleep 1.2;
		deleteVehicle _soundSource;
	};
	removeMissionEventHandler ["Draw3D", _drawEH];
	deleteVehicle _missile;
	deleteVehicle _source;
};
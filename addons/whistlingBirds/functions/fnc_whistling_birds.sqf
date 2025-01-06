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
		drawIcon3D["\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa", [1, 1, 1, 1], ASLToAGL aimPos (_thisArgs select 0), 1, 1, 0, "", 0];
	}, [_target]];

	_timeAlive = 0;
	_lifetime = 4;

	    _G = [0, 0, 9.905]; // Gravity Constant
	_time_step = 0.02;
	    _N = 4; // Navigation Constant
	    _thrust = 20; // Missile thrust (N)
	    _mass = getMass _missile; // Missile mass (kg)
	if (_mass == 0) then {
		_mass = 0.01
	};
	    _maxTurnRate = 60; // max turn rate (rad/s)

	    // Particle Effects
	_source = '#particlesource' createVehicle (getPosASL _missile);
	_source setParticleClass "Flare2";
	_source attachTo [_missile, [0, 0, 0], "Exhaust"];

	while { _timeAlive < _lifetime } do {
		_targetPosition = aimPos _target;
		_targetVelocity = velocity _target;
		_missilePosition = getPosASL _missile;
		_missileVelocity = velocity _missile;
		        // Draw line and target icon.
		       // drawLine3D [getPos _missile, ASLToAGL _targetPosition, [1, 1, 1, 1]];
		_dir = vectorDir _missile;
		_up = vectorUp _missile;

		        // Calculate LOS vector and direction
		_LOS = _targetPosition vectorDiff _missilePosition;
		_LOS_mag = vectorMagnitude _LOS;
		if (_LOS_mag <= 0.5) then {
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

		// LOS rate (Cross product of LOS and relative velocity.)
		_LOS_dir = vectorNormalized _LOS;
		_LOS_rate = _LOS vectorCrossProduct (_targetVelocity vectorDiff _missileVelocity) vectorMultiply (1 / (vectorMagnitudeSqr _LOS));

		// Guidance command (Proportional Navigation)
		_a_command = (_LOS_rate vectorCrossProduct _missileVelocity) vectorMultiply _N;
		_a_command_mag = vectorMagnitude _a_command;

		_a_command = _a_command vectorAdd (_LOS_dir vectorMultiply (_thrust / _mass));

		_a_m = _a_command vectorAdd _G;

		_missile setVelocity (_missileVelocity vectorAdd (_a_m vectorMultiply _time_step));

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
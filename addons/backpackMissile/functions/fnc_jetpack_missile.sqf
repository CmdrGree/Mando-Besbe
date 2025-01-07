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
	player setVariable ["BackpackMissileTargeting", false];
	player setVariable ["BackpackMissileLoaded", false];

	_missile = createVehicle ["R_MRAAWS_HE_F", (getPosATL player) vectorAdd [0, 0, 0], [], 0, "CAN_COLLIDE"];

	_missile attachTo [player, [0, -0.2, 1], "spine3"];
	// _missile setVectorDirAndUp (player selectionVectorDirAndUp ["spine3", "Memory"]);
	detach _missile;

	// Missile orientation and initial velocity.
	_missile setVectorDirAndUp [[0, 0, -1], [0, 1, 0]];
	_missile setVelocityModelSpace[0, -20, 0];
	_timeAlive = 0;
	_lifetime = 4;

	private _launchSounds = [QGVAR(LaunchSound1), QGVAR(LaunchSound2), QGVAR(LaunchSound3)];
	private _soundSource = '#particlesource' createVehicle getPos (_missile);
	_soundSource attachTo [_missile, [0, 0, 0]];
	_soundSource say3D [selectRandom _launchSounds, 10000, 1, 0, 0, true];

	_drawEH = addMissionEventHandler ["Draw3D", {
		_thisArgs params ["_missile", "_target", "_isVehicle", "_offset"];

		if (_isVehicle) then {
			private _targetPos = aimPos _target;
			if (count _offset == 3) then {
				_targetPos vectorAdd _offset;
			};
			drawLine3D [getPos _missile, ASLToAGL _targetPos, [1, 1, 1, 1]];
			drawIcon3D["\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa", [1, 1, 1, 1], ASLToAGL _targetPos, 1, 1, 0, "", 0];
		} else {
			drawLine3D [getPos _missile, ASLToAGL _target, [1, 1, 1, 1]];
			drawIcon3D["\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa", [1, 1, 1, 1], ASLToAGL _target, 1, 1, 0, "", 0];
		};
	}, [_missile, _target, _isVehicle, _offset]];

	_vehicleDamage = 0.5;
	_G = [0, 0, 9.905]; // Gravity Constant
	_time_step = 0.02;
	_N = 4; // Navigation Constant
	_thrust = 2; // Missile thrust (N)
	_mass = getMass _missile; // Missile mass (kg)
	if (_mass == 0) then {
		_mass = 0.01
	};
	_maxTurnRate = 30; // max turn rate (rad/s)

	while { alive _missile && _timeAlive < _lifetime } do {
		_targetPosition = _target;
		_targetVelocity = [0, 0, 0];
		_missilePosition = getPosASL _missile;
		_missileVelocity = velocity _missile;
		// Draw line and target icon.
		if (_isVehicle) then {
			if (count _offset > 0) then {
				_targetPosition = _target modelToWorld _offset;
			} else {
				_targetPosition = aimPos _target
			};
			_targetVelocity = velocity _target;
		};

		_dir = vectorDir _missile;
		_up = vectorUp _missile;

		// Calculate LineOfSight vector and direction
		private _LineOfSight = _targetPosition vectorDiff _missilePosition;

		/* if (vectorMagnitude _LineOfSight; <= 3 && _isVehicle) then {
				_missile setDamage 1;
				_target setDamage (damage _target + _vehicleDamage)
		};*/

		// LineOfSight rate (Cross product of LineOfSight and relative velocity.)
		private _LineOfSight_dir = vectorNormalized _LineOfSight;
		private _LineOfSight_rate = _LineOfSight vectorCrossProduct (_targetVelocity vectorDiff _missileVelocity) vectorMultiply (1 / (vectorMagnitudeSqr _LineOfSight));

		// Guidance command (Proportional Navigation)
		_accel_command = (_LineOfSight_rate vectorCrossProduct _missileVelocity) vectorMultiply _N;

		// Add thrust
		_accel_command = _accel_command vectorAdd (_LineOfSight_dir vectorMultiply (_thrust / _mass));

		// Limit commanded acceleration by thrust
		if (vectorMagnitude _accel_command > _thrust / _mass) then {
			_accel_command = (vectorNormalized _accel_command) vectorMultiply (_thrust / _mass);
		};

		// Limit commanded acceleration by turn rate
		_angular_velocity = vectorMagnitude _LineOfSight_rate;
		if (_angular_velocity > _maxTurnRate) then {
			_accel_command = _accel_command vectorMultiply (_maxTurnRate / _angular_velocity);
		};

		// Compensate for gravity
		_accel_m = _accel_command vectorAdd _G;

		// apply new velocity
		_missile setVelocity (_missileVelocity vectorAdd (_accel_m vectorMultiply _time_step));

		// Lifetime step.
		_timeAlive = _timeAlive + _time_step;
		sleep _time_step;
	};
	removeMissionEventHandler ["Draw3D", _drawEH];
	deleteVehicle _missile;
	sleep ((_target distance player) / 340.29);
	deleteVehicle _soundSource;
};
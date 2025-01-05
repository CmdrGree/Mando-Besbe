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
_count = player getVariable "_count";
if (! isNil "_target" && _count > 0) then {
	player setVariable ["_count", _count-1];
	// _missile  = createVehicle ["R_MRAAWS_HE_F", (getPosATL player) vectorAdd [0, 0, 0], [], 0, "CAN_COLLIDE"];
	_missile = createVehicle ["R_MRAAWS_HE_F", (getPosATL player) vectorAdd [0, 0, 0], [], 0, "CAN_COLLIDE"];
	_missile attachTo [player, [0, -0.2, 1], "spine3"];
	// _missile setVectorDirAndUp (player selectionVectorDirAndUp ["spine3", "Memory"]);
	detach _missile;
	_missile setVectorDirAndUp [[0, 0, -1], [0, 1, 0]];
	_missile setVelocityModelSpace[0, -20, 0];
	_timeAlive = 0;
	_lifetime = 4;

	_drawEH = addMissionEventHandler ["Draw3D", {
		_missile = _thisArgs select 0;
		_target = _thisArgs select 1;
		_isVehicle = _thisArgs select 2;
		if (_isVehicle) then {
			drawLine3D [getPos _missile, ASLToAGL (aimPos _target), [1, 1, 1, 1]];
			drawIcon3D["\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa", [1, 1, 1, 1], ASLToAGL (aimPos _targetPosition), 1, 1, 0, "", 0];
		} else {
			drawLine3D [getPos _missile, ASLToAGL _target, [1, 1, 1, 1]];
			drawIcon3D["\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa", [1, 1, 1, 1], ASLToAGL _target, 1, 1, 0, "", 0];
		};
	}, [_missile, _target, _isVehicle]];

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

		// Calculate LOS vector and direction
		_LOS = _targetPosition vectorDiff _missilePosition;
		_LOS_mag = vectorMagnitude _LOS;
		/* if (_LOS_mag <= 3 && _isVehicle) then {
				_missile setDamage 1;
				_target setDamage (damage _target + _vehicleDamage)
		};*/

		// LOS rate (Cross product of LOS and relative velocity.)
		_LOS_dir = vectorNormalized _LOS;
		_LOS_rate = _LOS vectorCrossProduct (_targetVelocity vectorDiff _missileVelocity) vectorMultiply (1 / (vectorMagnitudeSqr _LOS));

		// Guidance command (Proportional Navigation)
		_a_command = (_LOS_rate vectorCrossProduct _missileVelocity) vectorMultiply _N;
		_a_command_mag = vectorMagnitude _a_command;

		_a_command = _a_command vectorAdd (_LOS_dir vectorMultiply (_thrust / _mass));

		// Limit commanded acceleration by thrust
		if (_a_command_mag > _thrust / _mass) then {
			_a_command = (vectorNormalized _a_command) vectorMultiply (_thrust / _mass);
		};

		_angular_velocity = vectorMagnitude _LOS_rate;
		if (_angular_velocity > _maxTurnRate) then {
			_a_command = _a_command vectorMultiply (_maxTurnRate / _angular_velocity);
		};

		_a_m = _a_command vectorAdd _G;

		_missile setVelocity (_missileVelocity vectorAdd (_a_m vectorMultiply _time_step));

		// Lifetime step.
		_timeAlive = _timeAlive + _time_step;
		sleep _time_step;
	};
	removeMissionEventHandler ["Draw3D", _drawEH];
	deleteVehicle _missile;
};
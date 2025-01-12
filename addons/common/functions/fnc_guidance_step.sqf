#include "..\script_component.hpp"
/*
	* Author: Gree
	* A function that calculates the guidance step for a guided missile.
	*
	* Arguments:
	* target - (Object) or (position)
	* missile - Missile (Object)
	* mass - (Number) Mass of the missile.
	* thrust (Number) Thrust of the missile.
	* max_turn_rate - (Number) Maximum turn rate of the missile.
	* is_vehicle - (Boolean) if the target is a vehicle or not.
	* time_step - (Seconds) How long should the missile sleep between steps.
	* turn - (Boolean) if the missile should turn.
	* limit - (Boolean) whether to limit missile by turn rate and mass.
	* offset - (Vector3) the offset for the missile.
	*
	* Return Value:
	* distance_to_target - (Number)
	*
	* Example:
	* [_target, _missile, _mass, _max_turn_rate, _is_vehicle, _time_step, true, true, []] call mndb_common_fnc_guidance_step;
	*
	* Public: No
 */
params ["_target", "_missile", "_mass", "_thrust", "_max_turn_rate", "_is_vehicle", "_time_step", "_turn", "_limit", ["_offset", []]];

private _grav_const = [0, 0, 9.905]; // Gravity Constant
private _nav_const = 4; // Navigation Constant

private _target_position = _target;
private _target_velocity = [0, 0, 0];
private _missile_position = getPosASL _missile;
private _missile_velocity = velocity _missile;
private _dir = vectorDir _missile;
private _up = vectorUp _missile;

if (_is_vehicle) then {
	if (count _offset > 0) then {
		_target_position = _target modelToWorld _offset;
	} else {
		_target_position = aimPos _target;
	};
	_target_velocity = velocity _target;
};

// Calculate line of sight vector and direction
private _line_of_sight = _target_position vectorDiff _missile_position;

// Line of sight rate (Cross product of line of sight and relative velocity.)
private _line_of_sight_dir = vectorNormalized _line_of_sight;
private _line_of_sight_rate = _line_of_sight vectorCrossProduct (_target_velocity vectorDiff _missile_velocity) vectorMultiply (1 / (vectorMagnitudeSqr _line_of_sight));

// Guidance command (Proportional Navigation)
private _accel_command = (_line_of_sight_rate vectorCrossProduct _missile_velocity) vectorMultiply _nav_const;

// Add acceleration from thrust
_accel_command = _accel_command vectorAdd (_line_of_sight_dir vectorMultiply (_thrust / _mass));

if(_limit) then {
	// Limit commanded acceleration by thrust
	if (vectorMagnitude _accel_command > _thrust / _mass) then {
		_accel_command = (vectorNormalized _accel_command) vectorMultiply (_thrust / _mass);
	};

	// Limit commanded acceleration by turn rate
	_angular_velocity = vectorMagnitude _line_of_sight_rate;
	if (_angular_velocity > _max_turn_rate) then {
		_accel_command = _accel_command vectorMultiply (_max_turn_rate / _angular_velocity);
	};
};

// Compensate for gravity
private _accel_m = _accel_command vectorAdd _grav_const;

// apply new velocity
_missile setVelocity (_missile_velocity vectorAdd (_accel_m vectorMultiply _time_step));

if (_turn) then {
	private _dir_vector = vectorNormalized _accel_command;

	// Gradual blending of current direction and target direction
	private _current_dir = vectorDir _missile;
	private _new_dir = vectorNormalized (_current_dir vectorAdd (_dir_vector vectorMultiply 0.1));

	// Recalculate up vector for stability
	private _up_vector = vectorNormalized (_new_dir vectorCrossProduct [0, 0, 1]); // Perpendicular vector
	private _up_vector = vectorNormalized (_up_vector vectorCrossProduct _new_dir); // Ensure orthogonal to forward vector

	_missile setVectorDirAndUp [
		_new_dir,
		_up_vector
	];
};

private _distance_to_target = vectorMagnitude _line_of_sight;
_distance_to_target;
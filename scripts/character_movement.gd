extends CharacterBody2D
class_name PlatformerCharacterBody

@export var horizontal_accel_speed: float;
@export var max_walk_speed: float;
@export var jump_y_vel: float;
@export var reverse_boost: float;
@export var air_friction: float;
@export var leading_jump_buffer: float;
var jump_timer: float;
@export var trailing_jump_buffer: float;
var ground_timer: float;
@export var input_direction: InputDirection = null;
var gravity_multiplier: float = 1;

func jump():
	self.jump_timer = self.leading_jump_buffer;

func _physics_process(delta: float):
	if self.jump_timer > 0.:
		self.jump_timer -= delta;
		
	if self.ground_timer > 0.:
		self.ground_timer -= delta;
	
	if self.is_on_floor():
		self.ground_timer = self.trailing_jump_buffer;
	
	var up = self.get_up_direction();
	var left = Vector2(up.y, -up.x);
	var temp_velocity = self.get_velocity();
	
	var delta_v = Vector2(0., 0.);
	var x_axis = self.input_direction.get_direction().x;
	if x_axis != 0:
		var distance_from_max_v = self.max_walk_speed * abs(x_axis) + left.dot(temp_velocity) * sign(x_axis);
		if self.is_on_floor() && (left.dot(temp_velocity) * sign(x_axis) > 0.):
			delta_v += -temp_velocity.project(left) * self.reverse_boost;
		
		if distance_from_max_v > 0.:
			if distance_from_max_v < self.horizontal_accel_speed * delta :
				delta_v += -sign(x_axis) * left * (distance_from_max_v / delta);
			else:
				delta_v += -sign(x_axis) * self.horizontal_accel_speed * left;
	else:
		if self.is_on_floor():
			delta_v += -temp_velocity.project(left) * self.reverse_boost;
	delta_v += self.get_gravity() * self.gravity_multiplier;
	delta_v += -temp_velocity * self.air_friction;

	var delta_v_instant = Vector2(0., 0.);

	if (self.jump_timer > 0.) && (self.ground_timer > 0.):
		self.jump_timer = 0.;
		self.ground_timer = 0.;
		delta_v_instant += up * self.jump_y_vel;
		delta_v_instant += -temp_velocity.project(up);
	
	self.set_velocity(temp_velocity + delta_v * delta + delta_v_instant);
	self.move_and_slide();

func set_gravity_multiplier(multiplier: float):
	self.gravity_multiplier = multiplier;

func reset_gravity_multiplier():
	self.gravity_multiplier = 1;

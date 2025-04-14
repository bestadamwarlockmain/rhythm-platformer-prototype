extends Node
class_name PlayerDash

@export var character_body: PlatformerCharacterBody;
@export var lock_acceleration_timer: Timer;
@export var input_direction: InputDirection;
var last_nonzero_x_direction: Vector2 = Vector2.LEFT;

@export var dash_timer: Timer;

@export var dash_speed: float;
@export var dash_end_speed_scale: float;

func _physics_process(delta: float) -> void:
	var input_dir = input_direction.get_direction();
	if input_dir.x > 0:
		self.last_nonzero_x_direction = Vector2.RIGHT;
	elif input_dir.x < 0:
		self.last_nonzero_x_direction = Vector2.LEFT;

func dash():
	if self.lock_acceleration_timer.is_stopped() && self.dash_timer.is_stopped():
		self.dash_timer.start();
		self.lock_acceleration_timer.start(self.dash_timer.wait_time);
		character_body.add_instant_acceleration(self.get_dash_direction() * dash_speed - self.character_body.velocity);

func dash_end():
	self.character_body.add_instant_acceleration(-self.character_body.velocity * (1 - self.dash_end_speed_scale));

func get_dash_direction() -> Vector2:
	if self.input_direction.get_direction() == Vector2.ZERO:
		return self.last_nonzero_x_direction;
	return self.input_direction.get_direction();

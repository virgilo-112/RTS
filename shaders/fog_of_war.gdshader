shader_type canvas_item;

uniform vec2 object_positions[128];
uniform float object_radii[128];
uniform int object_count;

void fragment() {
	vec2 world_position = UV * vec2(10000.0, 6000.0);

	float alpha = 1.0;

	for (int i = 0; i < object_count; i++) {
		float distance_to_object = distance(
			world_position,
			object_positions[i]
		);

		if (distance_to_object < object_radii[i]) {
			alpha = 0.0;
		}
	}

	COLOR = vec4(0.0, 0.0, 0.0, alpha);
}
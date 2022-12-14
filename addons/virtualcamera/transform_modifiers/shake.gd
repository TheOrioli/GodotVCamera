tool
extends "res://addons/virtualcamera/transform_modifiers/transform_modifier.gd"

class_name Shake

export var noise : OpenSimplexNoise
export var speed : float = 1.0

export(float, 0, 1) var intensity : float = 1.0
export(float, EASE) var intensity_curve : float = 2.0
export var intensity_decrease_rate : float = 0.0

export var translation_strength : Vector3 = Vector3.ZERO
export var rotation_strength : Vector3 = Vector3.ZERO

var time : float = 0.0

func _ready():
	if not noise:
		noise = OpenSimplexNoise.new()
		noise.seed = get_instance_id()
		noise.octaves = 4
		noise.persistence = 0.8

const DEG2RAD = TAU / 360

func _physics_process(delta : float):
	if noise:
		time += delta * speed * 100
		
		if not Engine.editor_hint:
			intensity = max(0, intensity - intensity_decrease_rate * delta)
		var amplitude = ease(intensity, intensity_curve)
		
		translation = Vector3(noise.get_noise_1d(time), noise.get_noise_1d(time - 10000), noise.get_noise_1d(time - 20000))
		translation *= translation_strength * amplitude
		
		rotation = Vector3(noise.get_noise_1d(time - 30000), noise.get_noise_1d(time - 40000), noise.get_noise_1d(time - 50000))
		rotation *= rotation_strength * DEG2RAD * amplitude


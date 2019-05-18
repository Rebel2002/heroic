tool
extends Sprite

enum Arch {NoArch, SimpleArch, DecoratedArch}

export(int, 7) var type setget set_type
export(Arch) var arch setget set_arch

func set_type(value: int) -> void:
	type = value
	frame = type

func set_arch(value: int) -> void:
	arch = value
	match value:
		Arch.NoArch:
			$Arch.visible = false
			$ArchDecoration.visible = false
		Arch.SimpleArch:
			$Arch.visible = true
			$ArchDecoration.visible = false
		Arch.DecoratedArch:
			$Arch.visible = true
			$ArchDecoration.visible = true
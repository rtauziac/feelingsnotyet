extends "res://dialog/dialog_item.gd"

class_name TextDialog


export (String, MULTILINE) var text: String
export (String) var name: String
export (Texture) var portrait: Texture
export (bool) var blink: bool # Adds a subtle blink before text appears to make speaker change more clear

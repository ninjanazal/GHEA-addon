extends Node


#* - - - - - - - - - -
# Audio loaded resources
#* - - - - - - - - - -
var __audio_resources__ : Dictionary = {
	"bg1" : preload("res://assets/Audio/Music/electronic-future-beats-117997.mp3"),
	"sfx1" : preload("res://assets/Audio/sfx/MI_SFX 10.mp3"),
	"sfx2" : preload("res://assets/Audio/sfx/MI_SFX 33.mp3")
 };


onready var comps := {
	"playBg" : get_node("view/playBackground"),
	"pauseBg" : get_node("view/pauseBackground"),
	"playSfx1" : get_node("view/playSfx1"),
	"playSfx2" : get_node("view/playSfx2"),
	"muteBg" : get_node("view/mutedBGBus"),
	"muteSfx" : get_node("view/mutedSFXBus"),
	"bgVolumeVal" : get_node("view/BgVolumeValue"),
	"sfxVolumeVal" : get_node("view/SfxVolumeValue"),
	"bgVolumeSlide" : get_node("view/bgVolume"),
	"sfxVolumeSlide" : get_node("view/SfxVolume") 
}

#* - - - - - - - - - -
# _Ready function override
#* - - - - - - - - - -
func _ready():
	ExternalAudio.createExternalBus("sfxBus");
	ExternalAudio.addPlayer("sfxBus", "sfx1P");

	ExternalAudio.createExternalBus("musicBus");
	ExternalAudio.addPlayer("musicBus", "backgroundP");
	ExternalAudio.playAudio("backgroundP", __audio_resources__.bg1, 0.1, true);

	comps.muteBg.set_pressed(ExternalAudio.isBusMuted("musicBus"));
	comps.bgVolumeSlide.set_value(ExternalAudio.getBusVolume("musicBus"));
	comps.bgVolumeVal.set_text(str(int(ExternalAudio.getBusVolume("musicBus") * 100.0)));

	comps.muteSfx.set_pressed(ExternalAudio.isBusMuted("sfxBus"));
	comps.sfxVolumeSlide.set_value(ExternalAudio.getBusVolume("sfxBus"));
	comps.sfxVolumeVal.set_text(str(int(ExternalAudio.getBusVolume("sfxBus") * 100.0)));

	__create_connections__();

#* - - - - - - - - - -
# Input callback functions
#* - - - - - - - - - -
func __create_connections__():
	comps.playBg.connect("pressed", self, "__on_press_playBg__");
	comps.pauseBg.connect("pressed", self, "__on_press_pauseBg__");
	comps.muteBg.connect("pressed", self, "__on_press_muteBg__");
	comps.bgVolumeSlide.connect("value_changed", self, "__on_bgSlider_volume_change__");

	comps.playSfx1.connect("pressed", self, "__on_press_playSfx1__");
	comps.playSfx2.connect("pressed", self, "__on_press_playSfx2__");
	comps.muteSfx.connect("pressed", self, "__on_press_muteSfx__");
	comps.sfxVolumeSlide.connect("value_changed", self, "__on_sfxSlider_volume_change__");


func __on_press_playBg__():
	ExternalAudio.playAudio("backgroundP", __audio_resources__.bg1, 0.1, true);
func __on_press_pauseBg__():
	if(ExternalAudio.isPlayerPaused("backgroundP")):
		ExternalAudio.resumePlayer("backgroundP");
		return;
	ExternalAudio.pausePlayer("backgroundP");

func __on_press_muteBg__():
	ExternalAudio.muteBus("musicBus", !ExternalAudio.isBusMuted("musicBus"));
	comps.muteBg.set_pressed(ExternalAudio.isBusMuted("musicBus"));

func __on_bgSlider_volume_change__(value):
	ExternalAudio.changeBusVolume("musicBus", value);
	comps.bgVolumeVal.set_text(str(int(ExternalAudio.getBusVolume("musicBus") * 100.0)));


func __on_press_playSfx1__():
	ExternalAudio.playAudio("sfx1P", __audio_resources__.sfx1, 0.25, true);
func __on_press_playSfx2__():
	ExternalAudio.playAudio("sfx1P", __audio_resources__.sfx2, 0.5, false);
func __on_press_muteSfx__():
	ExternalAudio.muteBus("sfxBus", !ExternalAudio.isBusMuted("sfxBus"));
	comps.muteSfx.set_pressed(ExternalAudio.isBusMuted("sfxBus"));

func __on_sfxSlider_volume_change__(value):
	ExternalAudio.changeBusVolume("sfxBus", value);
	comps.sfxVolumeVal.set_text(str(int(ExternalAudio.getBusVolume("sfxBus") * 100.0)));

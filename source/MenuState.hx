import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	var playButton:FlxButton;

	override function create()
	{
		super.create();

		playButton = new FlxButton(0, 0, "Play!", clickPlay);
		playButton.screenCenter();
		add(playButton);
	}

	function clickPlay()
	{
		FlxG.switchState(new PlayState());
	}
}

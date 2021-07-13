package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import levels.LevelHelper;

class PlayState extends FlxState
{
	var player:Player;
	var levels:LevelProject;

	override public function create()
	{
		levels = new LevelProject();
		var spriteGroup = new FlxSpriteGroup();
		levels.all_levels.Level_0.l_Background_Data.render(spriteGroup);
		spriteGroup.forEach(function(sprite)
		{
			sprite.width = 16;
			sprite.height = 16;
		});
		add(spriteGroup);

		super.create();
		player = new Player(20, 20);
		add(player);

		var collGroup = LevelHelper.createColliderFromIntGrid(levels.all_levels.Level_0.l_Background_Data, 1);
		add(collGroup);

		FlxG.collide(player, collGroup);

		FlxG.camera.follow(player, FlxCameraFollowStyle.TOPDOWN_TIGHT);
		FlxG.camera.zoom = 3;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

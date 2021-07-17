package;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import weapons.Weapon;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	var background:FlxSprite;

	var weaponIconBg:FlxSprite;
	var weaponIcon:FlxSprite;

	public function new(camera:FlxCamera)
	{
		super();

		cameras = [camera];

		background = new FlxSprite().makeGraphic(FlxG.width, 80, FlxColor.BLACK);
		background.drawRect(0, 79, FlxG.width, 1, FlxColor.WHITE);
		add(background);

		weaponIconBg = new FlxSprite(4, 4).makeGraphic(18, 18, FlxColor.TRANSPARENT);
		weaponIconBg.drawRect(0, 0, 18, 18, FlxColor.fromInt(0x99FFFFFF), {thickness: 2, color: FlxColor.WHITE});
		weaponIconBg.setGraphicSize(72, 72);
		weaponIconBg.updateHitbox();
		add(weaponIconBg);

		weaponIcon = new FlxSprite(8, 8).makeGraphic(16, 16, FlxColor.WHITE);
		weaponIcon.setGraphicSize(64, 64);
		weaponIcon.updateHitbox();
		add(weaponIcon);

		forEach(function(sprite)
		{
			sprite.scrollFactor.set(0, 0);
			sprite.cameras = [camera];
		});
	}

	public function updateActiveWeapon(weapon:Weapon)
	{
		var icon = weapon.icon;
		weaponIcon.loadGraphicFromSprite(icon);
		weaponIcon.frame = icon.frame;
	}
}

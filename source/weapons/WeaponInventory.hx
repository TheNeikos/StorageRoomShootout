package weapons;

class WeaponInventory
{
	var weapons:Map<WeaponCategory, Array<Weapon>> = new Map();

	var currentCategory:WeaponCategory;
	var currentIndex:Int;

	public function new()
	{
		currentCategory = Melee;
		currentIndex = 0;
		for (cat in WeaponCategory.createAll())
		{
			weapons.set(cat, new Array());
		}
	}

	public function addWeapon(weapon:Weapon):Weapon
	{
		var category = weapons.get(weapon.getCategory());

		if (!category.contains(weapon))
		{
			category.push(weapon);
		}

		currentCategory = weapon.getCategory();
		currentIndex = category.indexOf(weapon);

		return category[category.indexOf(weapon)];
	}

	public function update(elapsed:Float)
	{
		for (cat in weapons.iterator())
		{
			for (weapon in cat)
			{
				weapon.update(elapsed);
			}
		}
	}

	public function nextWeapon():Weapon
	{
		var thisCat = weapons.get(currentCategory);

		currentIndex += 1;

		if (currentIndex >= thisCat.length)
		{
			while (true)
			{
				currentCategory = nextCategory(currentCategory);
				if (weapons.get(currentCategory).length > 0)
				{
					currentIndex = 0;
					break;
				}
			}
		}

		return weapons.get(currentCategory)[currentIndex];
	}

	public function prevWeapon():Weapon
	{
		currentIndex -= 1;

		if (currentIndex < 0)
		{
			while (true)
			{
				currentCategory = prevCategory(currentCategory);
				if (weapons.get(currentCategory).length > 0)
				{
					currentIndex = weapons.get(currentCategory).length - 1;
					break;
				}
			}
		}

		return weapons.get(currentCategory)[currentIndex];
	}
}

enum WeaponCategory
{
	Melee;
	Pistols;
}

function nextCategory(cat:WeaponCategory):WeaponCategory
{
	return switch (cat)
	{
		case Melee: Pistols;
		case Pistols: Melee;
	};
}

function prevCategory(cat:WeaponCategory):WeaponCategory
{
	return switch (cat)
	{
		case Melee: Pistols;
		case Pistols: Melee;
	};
}

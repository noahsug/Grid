package gridgame.entity.block
{
import flashx.textLayout.debug.assert;

import gridgame.Currency;
import gridgame.entity.Entity;
import gridgame.level.Level;

import org.flixel.FlxGroup;
import org.flixel.plugin.photonstorm.BaseTypes.Bullet;

public class BlockFactory
{
	private static var _blocks: FlxGroup = new FlxGroup();	
	private static var _currency: Currency;	
	private static var _targets: FlxGroup;
	private static var _level:Level;
	
	public static function setCurrency(currency:Currency):void
	{
		_currency = currency;
	}
	
	public static function setTargets(targets:FlxGroup):void
	{
		_targets = targets;
	}
	
	public static function setLevel(level:Level):void
	{
		_level = level;
	}
	
	public static function getBlockGroup():FlxGroup
	{
		return _blocks;
	}
		
	public static function makeWall():Block
	{
		return reviveBlock(Wall);
	}
	
	public static function makeTurret():Block
	{
		var turret:Turret = reviveBlock(Turret) as Turret;
		turret.setTargets(_targets);
		return turret;
	}
	
	public static function makeSupplier():Block
	{
		var supplier:Supplier = reviveBlock(Supplier) as Supplier;
		supplier.setCurrency(_currency);
		return supplier;
	}
	
	public static function makeBlock(B:Class):Block
	{
		if (B == Wall) return makeWall();
		if (B == Turret) return makeTurret();
		if (B == Supplier) return makeSupplier();		
		return null;
	}
	
	private static function reviveBlock(Obj:Class):Block
	{
		var block:Block = _blocks.recycle(Obj) as Block;
		block.revive();
		block.setLevel(_level);
		return block;
	}		
}
}
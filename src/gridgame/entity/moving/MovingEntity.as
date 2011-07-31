package gridgame.entity.moving
{
import gridgame.entity.Entity;
import gridgame.level.Level;
import gridgame.level.Space;

import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;

public class MovingEntity extends Entity
{
	private var _hitObject:FlxObject;
	public var movementBehavior: MovementBehavior;
	
	protected var _freezeDuration:Number;
	
	public function MovingEntity(img:Class=null)
	{
		_freezeDuration = 0;
		super(img);
	}
	
	public static function levelHit(entity:MovingEntity, block:FlxObject): void
	{
		entity.levelHit(block);
	}
	
	public override function setLevel(level:Level):void
	{
		super.setLevel(level);
		movementBehavior.setLevel(level);			
	}
	
	public function freeze(duration:Number):void
	{		
		_freezeDuration = duration;
		moves = false;
	}
	
	public override function update():void
	{
		handleFreezing();
		movementBehavior.update();		
		super.update();
		_hitObject = null;
	}		
	
	protected function handleFreezing():void
	{
		if (_freezeDuration > 0)
		{
			_freezeDuration -= FlxG.elapsed;
			if (_freezeDuration <= 0) moves = true;
		}
	}
	
	internal function get hitObject():FlxObject {
		return _hitObject;
	}
	
	internal function moveAlongPath():void
	{
		updatePathMotion();
	}
		
	internal function getSpaceInFront():Space 
	{
		var _destination:FlxPoint = _point;
		_destination.x = midpoint.x + Level.TileSize * movementBehavior.direction.x;
		_destination.y = midpoint.y + Level.TileSize * movementBehavior.direction.y;
		if (_level.isOutOfBounds(_destination)) return null;				
		return _level.getClosestSpace(_destination);
	}
			
	protected function levelHit(block:FlxObject):void
	{
		_hitObject = block;			
	}
}
}
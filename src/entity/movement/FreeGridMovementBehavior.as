package entity.movement
{

import entity.Entity;

import org.flixel.*;

public class FreeGridMovementBehavior extends MovementBehavior
{
	private static const Origin:FlxPoint = new FlxPoint(0, 0);
	
	private var _direction:FlxPoint = new FlxPoint();
	private var _prevDirection:FlxPoint = new FlxPoint();
	private var _destination:FlxPoint = new FlxPoint();
	private var _level:Level;
	
	public function FreeGridMovementBehavior(entity:Entity)
	{
		super(entity);		
	}
	
	public function setLevel(level:Level):void
	{
		_level = level;
	}
	
	public override function update():void
	{
		_prevDirection.copyFrom(_direction);
		getDirection();
		
		if (_direction.x == 0 && _direction.y == 0) { 			
			_entity.velocity.x = _entity.velocity.y = 0;	
			return;
		}
		if (_prevDirection.x == _direction.x && _prevDirection.y == _direction.y && _entity.pathSpeed != 0) {
			return;
		}
		var space:Space = _level.getClosestSpace(_entity.position);
		_currentDirection.copyFrom(_direction);
		_entity.angle = FlxU.getAngle(Origin, _direction);
		_destination.x = space.midpoint.x + Level.TileSize * _direction.x;	
		_destination.y = space.midpoint.y + Level.TileSize * _direction.y;	
		if (_level.isOutOfBounds(_destination) || _level.overlapsPoint(_destination))
		{			
			_entity.velocity.x = _entity.velocity.y = 0;
			return;
		}
		_entity.path = _level.findPath(_entity.position, _destination);
		_entity.followPath(_entity.path, _speed);
	}
	
	private function getDirection():void
	{
		_direction.x = _direction.y = 0;
		if (FlxG.keys.W || FlxG.keys.UP)
		{
			_direction.y = -1;
		}
		else if (FlxG.keys.S || FlxG.keys.DOWN)
		{
			_direction.y = 1;				
		}
		else if (FlxG.keys.D || FlxG.keys.RIGHT)
		{
			_direction.x = 1;
		}
		else if (FlxG.keys.A || FlxG.keys.LEFT)
		{
			_direction.x = -1;
		}
	}
}
}
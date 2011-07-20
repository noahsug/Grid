package gridgame.entity.moving
{
import gridgame.level.Level;

import org.flixel.*;

public /*abstract*/ class MovementBehavior
{
	protected var _speed:Number;
	protected var _currentDirection:FlxPoint = new FlxPoint(0, -1);
	protected var _entity:MovingEntity;
	protected var _level:Level;
	
	public function MovementBehavior(entity:MovingEntity)
	{
		_entity = entity;
	}
	
	public function setSpeed(speed:Number):void
	{
		_speed = speed;
	}
	
	public function setLevel(level:Level):void
	{
		_level = level;
	}
	
	public function update():void { } //abstract
	
	public function get direction():FlxPoint
	{
		return _currentDirection;
	}	
}
}
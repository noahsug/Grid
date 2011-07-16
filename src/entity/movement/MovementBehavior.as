package entity.movement
{
import entity.Entity;

import org.flixel.*;

public /*abstract*/ class MovementBehavior
{
	protected var _speed:Number;
	protected var _currentDirection:FlxPoint = new FlxPoint(0, -1);
	protected var _entity:Entity;

	public function MovementBehavior(entity:Entity)
	{
		_entity = entity;
	}
	
	public function setSpeed(speed:Number):void
	{
		_speed = speed;
	}
	
	public function update():void { } //abstract
	
	public function get direction():FlxPoint
	{
		return _currentDirection;
	}		
}
}
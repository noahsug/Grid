package gridgame.entity.moving
{
import flashx.textLayout.operations.CopyOperation;

import gridgame.entity.Entity;
import gridgame.level.Level;
import gridgame.level.Space;
import gridgame.utils.Utils;

import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import org.flixel.FlxU;

public class AugmentedMovementBehavior extends MovementBehavior
{	
	private var _direction:FlxPoint = new FlxPoint();	
	private var _prevDirection:FlxPoint = new FlxPoint();
	private var _pointToFollow: FlxPoint = new FlxPoint();
	
	public function AugmentedMovementBehavior(entity:MovingEntity)
	{
		super(entity);
		_entity.path = new FlxPath(new Array(_pointToFollow));
	}
	
	public override function update():void
	{
		_prevDirection.copyFrom(_direction);
		getDirection();
		_entity.velocity.x = _entity.velocity.y = 0;
		unclip();
		
		if (_direction.x == 0 && _direction.y == 0) return;
		
		if (!_currentDirection.equals(_direction))
		{
			_currentDirection.copyFrom(_direction);
			_entity.angle = FlxU.getAngle(Utils.Origin, _currentDirection);
		}		
		else if (_entity.hitObject && !_entity.getSpaceInFront().allowCollisions)
		{						
			var space:Space = _level.getClosestSpace(_entity.midpoint);
			_pointToFollow.copyFrom(space.midpoint);
			_entity.followPath(_entity.path);
			_entity.moveAlongPath();
		}
		else
		{
			_entity.stopFollowingPath();
			_entity.velocity.x = _speed * _currentDirection.x;
			_entity.velocity.y = _speed * _currentDirection.y;
		}
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
	
	private function unclip():void
	{
		var space:Space = _entity.getSpaceInFront();
		if (space && space.allowCollisions)
		{				
			var distanceDifference:Number = FlxU.getDistance(space.midpoint, _entity.midpoint) - (Level.TileSize + _entity.width) / 2;			
			if (distanceDifference < 0) {				
				_entity.x += _currentDirection.x * distanceDifference;
				_entity.y += _currentDirection.y * distanceDifference;
			}
		}
	}
}
}
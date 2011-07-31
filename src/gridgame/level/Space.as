package gridgame.level
{
import flash.geom.Point;

import gridgame.entity.Entity;
import gridgame.entity.block.Block;
import gridgame.utils.IntPoint;

import org.flixel.*;

public class Space
{
	private var _block:Block;
	private var _level:Level;
	private var _tileIndex:uint;
	private var _position:FlxPoint;
	private var _midpoint:FlxPoint = new FlxPoint();

	public function Space(level:Level, tileIndex:uint)
	{		
		_level = level;
		_tileIndex = tileIndex;
		_position = new FlxPoint();
		_position = _level.getPointFromIndex(tileIndex, _position);
		_midpoint.x = _position.x + Level.TileSize / 2;
		_midpoint.y = _position.y + Level.TileSize / 2;
	}
	
	public function get x():Number { return _position.x; }
	public function get y():Number { return _position.y; }
	
	public function get midpoint():FlxPoint { return _midpoint; }
	
	public function get position():FlxPoint { return _position; }
	
	public function get block():Block 
	{
		return _block; 
	}
	public function set block(block:Block):void 
	{ 	
		if (!block && _block)
			_level.setTileByIndex(_tileIndex, 0, true);
		if (!_block && block) {
			_level.setTileByIndex(_tileIndex, 1, false);
		}
		_block = block;
		if (_block)	_block.position = position;
	}
	
	public function get allowCollisions():Boolean { return _block != null; }
	
	public function removeBlock():void
	{
		if (_block) 
		{
			if (_block.alive)
				_block.kill();
			block = null;
		}
	}
}
}
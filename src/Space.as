package
{
import entity.Entity;

import org.flixel.*;

import utils.IntPoint;

public class Space
{
	private var _block:Entity;
	private var _level:Level;
	private var _tileIndex:uint;
	private var _position:FlxPoint;
	private var _midpoint:FlxPoint = new FlxPoint();

	public function Space(level:Level, tileIndex:uint)
	{		
		_level = level;
		_tileIndex = tileIndex;
		_position = _level.getPointFromIndex(tileIndex);
		_midpoint.x = _position.x + Level.TileSize / 2;
		_midpoint.y = _position.y + Level.TileSize / 2;
	}
	
	public function get x():Number { return _position.x; }
	public function get y():Number { return _position.y; }
	
	public function get midpoint():FlxPoint { return _midpoint; }
	
	public function get position():FlxPoint { return _position; }
	
	public function get block():Entity { return _block; }
	public function set block(block:Entity):void 
	{ 	
		if (block == null && _block != null)
			_level.setTileByIndex(_tileIndex, 0, true);
		if (_block == null && block != null) {
			_level.setTileByIndex(_tileIndex, 1, true);
		}		
		_block = block;
		if (_block != null)
			_block.setPosition(_position.x, _position.y);
	}
	
	public function get allowCollisions():Boolean { return _block != null; }
}
}
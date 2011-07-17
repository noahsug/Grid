package gridgame.level 
{
	import gridgame.entity.block.Block;
	import gridgame.entity.block.BlockFactory;
	import gridgame.entity.*;
	
	import org.flixel.*;
	
	public class Level extends FlxTilemap
	{
		[Embed(source="./assets/tiles.png")] private var TilesImg:Class;
		
		public static const TileSize:int = 12;		
		private static const CollideIndex:int = 1;
		
		private var _spaces:Array; 
		private var _tx:int, _ty:int;
		
		public function Level()
		{
			super();
			
			var mapDataCsv:String = LevelGenerator.instance.generateLevel(
				FlxG.width / TileSize, FlxG.height / TileSize);
			loadMap(mapDataCsv, TilesImg, TileSize, TileSize, FlxTilemap.OFF, 0, 0, CollideIndex);
			
			_spaces = new Array(widthInTiles * heightInTiles);
			var block:Block;
			for (var i:int = 0; i < _spaces.length; i++) 
			{				
				if (getTileByIndex(i) == 1) 
					block = BlockFactory.makeWall()
				else
					block = null;
				_spaces[i] = new Space(this, i);
				_spaces[i].block = block;
			}
		}
		
		public function getPointFromIndex(i:int, point:FlxPoint=null):FlxPoint
		{
			if (point == null) 
				point = new FlxPoint();
			point.x = (i % widthInTiles) * TileSize;
			point.y = (int)(i / widthInTiles) * TileSize;
			return point;
		}
		
		public function getClosestSpace(pos:FlxPoint):Space
		{
			setTilePos(pos.x, pos.y);
			return getSpace(_tx, _ty);
		}

		public function getSpace(x:int, y:int):Space
		{
			return _spaces[_ty * widthInTiles + _tx];
		}
		
		public function isOutOfBounds(point:FlxPoint):Boolean 
		{
			return point.x < 0 || point.x >= width ||
				point.y < 0 || point.y >= height;
		}
		
		public function getClosestOpenSpace(x:Number, y:Number):Space
		{			
			setTilePos(x, y);
			var numTurns:int = 3;
			var totalDistance:int = 1;	
			var distance:int = 1;
			var xDir:int, yDir:int;
			var space:Space = getSpace(_tx, _ty);
			
			while (space.allowCollisions)
			{
				if (distance == totalDistance) {
					numTurns++;
					distance = 1;
					switch (numTurns)
					{
					case 1:
						xDir = 0;
						yDir = 1;
						break;
					case 2:
						xDir = -1;
						yDir = 0;
						break;
					case 3:
						xDir = 0;
						yDir = -1;
						break;
					case 4:
						_tx--;
						_ty--;
						totalDistance += 2;
						numTurns = 0;						
						xDir = 1;
						yDir = 0;						
					}
				}
				_tx += xDir;
				_ty += yDir;
				distance++;				
				space = getSpace(_tx, _ty);
			}
			
			return space;
		}	
		
		private function setTilePos(x:Number, y:Number):void 
		{
			_tx = x / TileSize;
			_ty = y / TileSize;
		}
	}
}
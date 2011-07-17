package gridgame.level 
{
	import org.flixel.*;
	
	public class LevelGenerator
	{
		private static var _instance:LevelGenerator;
		public static function get instance():LevelGenerator
		{		
			if (_instance == null) _instance = new LevelGenerator();
			return _instance;
		}
		
		private static const StartChance:Number = .2;
		private static const StopChance:Number = .5;
		private static const Slope:Number = .6;
		
		private var _width:int;
		private var _height:int;
		private var _grid:Array;
		
		public function generateLevel(width:int, height:int):String
		{						
			_width = width;
			_height = height;
			
			var levelArray:Array = generateLevelArray();
			var levelCSV:String = FlxTilemap.arrayToCSV(levelArray, _width);
			return levelCSV;
		}
		
		private function generateLevelArray():Array
		{
			var levelArray:Array = new Array(_width * _height);
			_grid = new Array(_width);
			for (var x:int = 0; x < _width; x++)
			{
				var col:Array = new Array(_height);
				_grid[x] = col;
				for (var y:int = 0; y < _height; y++)
				{
					_grid[x][y] = getBlockTypeNeighbors(x, y);
					levelArray[y * _width + x] = _grid[x][y];
				}				
			}
			return levelArray;
		}
		
		private function getBlockTypeNeighbors(x:int, y:int):int
		{
			var neighbors:int = 0;
			for (var rx:int = -1; rx <= 1; rx++)
			{
				for (var ry:int = -1; ry <= 1; ry++) {
					if (rx == 0 && ry == 0) continue;
					if (isFull(x + rx, y + ry)) neighbors++;
				}
			}						
			
			if (random < StartChance) return 1;
			if (random < StopChance) return 0;			
			return Math.pow(random * 5, Slope) < Math.pow(neighbors, Slope) ? 1: 0;
		}
		
		/*private function getBlockTypeWalling(x:int, y:int):int
		{			
			var makesLeftWall:Boolean = 
				isFull(x - 1, y - 1) ||
				isFull(x - 1, y) ||
				isFull(x - 1, y + 1);
			var makesRightWall:Boolean = 
				isFull(x + 1, y - 1) ||
				isFull(x + 1, y) ||
				isFull(x + 1, y + 1);
			
			var makesTopWall:Boolean = 
				isFull(x - 1, y - 1) ||
				isFull(x, y - 1) ||
				isFull(x + 1, y - 1);
			var makesBotWall:Boolean = 
				isFull(x - 1, y + 1) ||
				isFull(x, y + 1) ||
				isFull(x + 1, y + 1);
		
			var makesHorizontalWall:Boolean = makesLeftWall && makesRightWall; 
			var makesVerticalWall:Boolean = makesTopWall && makesBotWall;
			
			var numWallsMade:int = 0;
			if (makesHorizontalWall) numWallsMade++;
			if (makesVerticalWall) numWallsMade++;
			
			var probability:Number;
			if (numWallsMade == 0) probability = .1;
			if (numWallsMade == 1) probability = .5;
			if (numWallsMade == 2) probability = .9;
			
			return random < probability ? 1 : 0;
		}*/
		
		private function isFull(x:int, y:int):Boolean 
		{
			if (x < 0 || x >= _width || y < 0 || y >= _height) return false;
			return _grid[x] != null && _grid[x][y] != null && _grid[x][y] > 0;
		}
		
		private function get random():Number 
		{ 
			return FlxG.random();
		}
	}
}
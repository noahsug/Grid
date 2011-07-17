package gridgame.entity.block
{
public class Turret extends Block
{	
	[Embed(source="./assets/turret.png")] private var TurretImg:Class;
	
	public function Turret()
	{
		super(TurretImg);
	}		
}
}
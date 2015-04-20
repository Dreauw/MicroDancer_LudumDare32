package entities 
{
	import net.flashpunk.World;
	import worlds.WorldGame;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class StopSkill extends Skill
	{
		
		public function StopSkill(world:World) {
			super(world, FP.screen.width / FP.screen.scale - 65, "Stop", [3, 1, 1, 3], 1);
		}
		
		
		override public function onCast():void {
			super.onCast();
			(world as WorldGame).stopConveyor();
		}
		
	}

}
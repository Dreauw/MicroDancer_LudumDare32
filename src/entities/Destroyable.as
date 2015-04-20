package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import utils.ComboGenerator;
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Destroyable extends Entity
	{
		protected var combo:Combo;
		public var inactive:Boolean;
		
		public function Destroyable() 
		{
			super(0, 0);
		}
		
		public function init(x:Number, y:Number, world:World):void {
			this.x = x;
			this.y = y;
			combo = new Combo(ComboGenerator.getInstance().getCombo(), 0.5, 2, this);
			world.add(combo);
		}
		
		public function getComboX():Number {
			return x;
		}
		
		public function getComboY():Number {
			return y;
		}
		
		
		public function switchOff():void {
			inactive = true;
		}
		
		public function onDestruction():void {
			FP.world.remove(combo);
		}
		
		public function getCombo() : Combo {
			return combo;
		}
		
	}

}
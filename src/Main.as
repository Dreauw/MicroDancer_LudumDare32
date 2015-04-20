package {
	import net.flashpunk.FP;
	import net.flashpunk.Engine;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import worlds.WorldGame;
	import utils.ComboGenerator;
	import worlds.WorldTitle;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	[SWF(backgroundColor="#202020", width="640", height="480")]
	[Frame(factoryClass = "Preloader")]
	public class Main extends Engine {
		public function Main() {
			super(640, 480, 60, false);
			//if (new Error().getStackTrace().search(/:[0-9]+]$/m) > -1) {
				//FP.console.enable();
				//FP.console.toggleKey = Key.F1;
			//}
			FP.screen.scale = 3;

			FP.world = new WorldTitle(); 
		}
	}
}
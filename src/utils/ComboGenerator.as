package utils 
{
	/**
	 * ...
	 * @author Dreauw
	 */
	public class ComboGenerator 
	{
		private static var instance:ComboGenerator = new ComboGenerator();
		public var maxComboSize:int = 3;
		private var minComboSize:int = 3;
		private const NB_COMBO:int = 4;
		
		private var lastCombo:Array;
		private var registeredCombos:Array;
		
		public function ComboGenerator()	{
			registeredCombos = new Array();
		}
		
		public static function getInstance() : ComboGenerator {
			return instance;
		}
		
		public function registerCombo(combo:Array):void {
			registeredCombos.push(combo);
		}
		
		
		public function getCombo():Array {
			var arr:Array = new Array();
			var comboSize:int = Math.round(minComboSize + Math.random() * (maxComboSize - minComboSize));
			
			for (var i:int = 0; i < comboSize; ++i) {
				arr.push(Math.floor(Math.random() * NB_COMBO));
			}
			
			// Check if last + new combo is composed of a registered (protected) combo
			var tmpArr:Array = arr;

			if (lastCombo != null) {
				tmpArr = lastCombo.concat(arr);
			}
			
			
			
			for (i = 0; i < registeredCombos.length; ++i) {
				var idx:int = -1;
				while ((idx = tmpArr.indexOf(registeredCombos[i][0], idx+1)) >= 0) {	
					var f:Boolean = true;
					for (var j:int = 1; j < registeredCombos[i].length; ++j) {
						if (tmpArr[idx + j] != registeredCombos[i][j]) {
							f = false;
							break;
						}
					}
					// If that's the case, we recreate the combo to remove the protected pattern
					if (f) {
						trace("Nope !");
						return getCombo();
					}
				}
			}
			
			
			return arr;
		}
		
	}

}
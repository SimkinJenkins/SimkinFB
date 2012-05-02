package net.structures {

	public class IDData {

		protected var _ID:String = "";
		protected var _name:String = "";

		public function get imageName():String {return _name;}
		public function set imageName($value:String):void {_name = $value;}

		public function set ID($value:String):void {
			_ID = $value;
		}

		public function get ID():String {
			return _ID;
		}

		public function IDData($data:Object) {
			_ID = $data.id;
			_name = $data.name;
		}

	}
}
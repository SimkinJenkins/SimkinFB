package net.structures {

	public class SimpleGraphicData {

		protected var _height:Number;
		protected var _width:Number;
		protected var _source:String;

		public function get source():String {
			return _source;
		}

		public function SimpleGraphicData($data:Object = null) {
			if($data) {
				_height = $data.height;
				_width = $data.width;
				_source = $data.source;
			}
		}

	}
}
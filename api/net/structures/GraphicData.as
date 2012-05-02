package net.structures {

	public class GraphicData extends SimpleGraphicData {

		protected var _icon:String;
		protected var _link:String;
		protected var _picture:String;

		public function get link():String {
			return _link;
		}

		public function GraphicData($data:Object = null) {
			super($data);
			if($data) {
				_icon = $data.icon;
				_link = $data.link;
				_picture = $data.picture;
				_source = $data.source;
			}
		}
	}
}
package net.core {

	public class EtniaFacebookGraph {

		protected var _userData:Object;
		protected var _appID:String = "";
		protected var _accessToken:String = "";

		private static var _instance:EtniaFacebookGraph;

		public function get accessToken():String {
			return _accessToken;
		}
		
		public function set accessToken($value:String):void {
			_accessToken = $value;
		}

		public function get appID():String {
			return _appID;
		}
		
		public function set appID($value:String):void {
			_appID = $value;
		}

		public function get userData():Object {
			return _userData;
		}

		public function set userData($value:Object):void {
			_userData = $value;
		}

		public function EtniaFacebookGraph($newCall:Function = null) {
			if ($newCall != EtniaFacebookGraph.getInstance) {
				throw new Error("URLManager");
			}
			if (_instance != null)			{
				throw new Error("URLManager");
			}
		}

		public static function getInstance():EtniaFacebookGraph {
			if (_instance == null )	{
				_instance = new EtniaFacebookGraph (arguments.callee);
			}
			return _instance;
		}

	}
}
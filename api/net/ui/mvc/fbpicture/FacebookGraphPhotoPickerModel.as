package net.ui.mvc.fbpicture {

	import com.ui.controllers.mvc.BasicFormStates;
	import com.ui.controllers.mvc.fbpicture.BasicFBPicturePickerStates;
	import com.ui.controllers.mvc.fbpicture.IPhotoPicker;
	import com.ui.controllers.mvc.models.BasicModel;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import net.structures.AlbumData;
	import net.structures.FBUserData;
	import net.structures.PhotoData;
	
	public class FacebookGraphPhotoPickerModel extends BasicModel implements IPhotoPicker {
		
		protected var _friends:Array;
		protected var _friendphotos:Array;
		protected var _friendAlbums:Array;
		protected var _albums:Array;
		protected var _photos:Array;
		protected var _uid:String;
		protected var _aid:String;
		protected var _needLogin:Boolean;
		protected var _currentAlbum:AlbumData;
		protected var _currentFriend:FBUserData;
		protected var _currentFriendAlbum:ThumbnailAlbumDataGraph;
		protected var _currentPhoto:PhotoData;
		protected var _currentPhotoURL:String;
		protected var _selectedPhoto:DisplayObject;
		protected var _pickerState:String;
		protected var _lastState:String;
		protected var _terms:Boolean = true;
		protected var _retries:uint = 3;
		protected var _currentRetry:uint = 0;
		protected var _currentCover:uint = 0;
		protected var _isMyAlbums:Boolean = true;

		public function FacebookGraphPhotoPickerModel() {
			super();
		}
		
		override protected function getErrorPhrase($ID:String):String {
			switch($ID) {
				case BasicFBPicturePickerStates.FRIEND_ALBUMS_ERROR:	return "LanguageManager.getInstance().getPhrase(21010)";
				case BasicFBPicturePickerStates.ALBUMS_LOAD_ERROR:		return "LanguageManager.getInstance().getPhrase(21012)";
				case BasicFBPicturePickerStates.TERMS_ERROR:			return "LanguageManager.getInstance().getPhrase(21008)";
			}
			return super.getErrorPhrase($ID);
		}
		
		public function set terms($value:Boolean):void {
			_terms = $value;
			//			dispatchEvent(new Event(ON_TERMS_CHANGE));
		}
		
		public function get terms():Boolean {
			return _terms;
		}
		
		public function set selectedPhoto($value:DisplayObject):void {
			_selectedPhoto = $value;
			setState(BasicFormStates.FINISHING);
		}
		
		public function get selectedPhoto():DisplayObject {
			return _selectedPhoto;
		}
		
		public function set albums($albums:Array):void {
			_albums = $albums;
		}
		
		public function get albums():Array {
			return _albums;
		}
		
		public function set photos($photos:Array):void {
			_photos = $photos;
			setState(BasicFBPicturePickerStates.PHOTOS_DATA_LOADED);
		}
		
		public function get photos():Array {
			return _photos;
		}
		
		public function set uid($user:String):void {
			_uid = $user;
		}
		
		public function get uid():String {
			return _uid;
		}
		
		public function set aid($album:String):void {
			_aid = $album;
		}
		
		public function get aid():String {
			return _aid;
		}
		
		override protected function initialize():void {
			super.initialize();
			setState(BasicFBPicturePickerStates.INIT);
		}
		
		override public function setState($ID:String):void {
			if(_currentState) {
				_lastState = _currentState;
			}
			_currentState = $ID;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setPicketState($state:String):void {
			_pickerState = $state;
		}
		
		public function get needLogin():Boolean {
			return _needLogin;
		}
		
		public function set needLogin($value:Boolean):void {
			_needLogin = $value;
		}
		
		public function get currentAlbum():AlbumData {
			return _currentAlbum;
		}
		
		public function set currentAlbum($album:AlbumData):void {
			_currentAlbum = $album;
		}
		
		public function get currentPhotoURL():String {
			return _currentPhotoURL;
		}
		
		public function set currentPhotoURL($value:String):void {
			_currentPhotoURL = $value;
		}
		
		public function get friends():Array {
			return _friends;
		}
		
		public function set friends($value:Array):void {
			_friends = $value;
		}
		
		public function set currentFriend($user:FBUserData):void {
			_currentFriend = $user;
		}
		
		public function get currentFriend():FBUserData {
			return _currentFriend;
		}
		
		public function set currentFriendAlbum($album:ThumbnailAlbumDataGraph):void {
			_currentFriendAlbum = $album;
		}
		
		public function get currentFriendAlbum():ThumbnailAlbumDataGraph {
			return _currentFriendAlbum;
		}
		
		public function set friendphotos($photos:Array):void {
			_friendphotos = $photos;
		}
		
		public function get friendphotos():Array {
			return _friendphotos;
		}
		
		public function set friendAlbums($albums:Array):void {
			_friendAlbums = $albums;
		}
		
		public function get friendAlbums():Array {
			return _friendAlbums;
		}
		
		public function get lastState():String {
			return _lastState;
		}
		
		public function get pickerState():String {
			return _pickerState;
		}

		public function set retries($value:uint):void {
			_retries = $value;
		}

		public function get retries():uint {
			return _retries;
		}

		public function set currentRetry($value:uint):void {
			_currentRetry = $value;
		}
		
		public function get currentRetry():uint {
			return _currentRetry;
		}

		public function get currentCover ():uint {
			return _currentCover;
		}
		
		public function set currentCover ($value:uint):void {
			_currentCover = $value;
			dispatchEvent(new Event(BasicFBPicturePickerStates.LOADING_COVER));
		}
		
		public function get isMyAlbums ():Boolean {
			return _isMyAlbums;
		}
		
		public function set isMyAlbums ($value:Boolean):void {
			_isMyAlbums = $value;
		}

	}
}
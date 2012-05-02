package net.ui.mvc.fbpicture {

	import com.graphics.gallery.ThumbnailEvent;
	import com.ui.controllers.mvc.fbpicture.BasicFBPicturePickerStates;
	import com.ui.controllers.mvc.interfaces.IController;
	import com.ui.controllers.mvc.interfaces.IModel;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BasicFriendsFBGraphPicturePickerView extends BasicFBGraphPicturePickerView {
		
		protected function get fbfPPController():BasicFriendsFBGraphPicturePickerController {
			return _controller as BasicFriendsFBGraphPicturePickerController;
		}
		
		public function BasicFriendsFBGraphPicturePickerView($model:IModel, $controller:IController=null, $graphic:Sprite=null){
			super($model, $controller, $graphic);
		}
		
		override protected function stateUpdate($event:Event):void {
			super.stateUpdate($event);
			switch(_model.currentState) {
				case BasicFBPicturePickerStates.FRIEND_ALBUM_SELECTED:	showSelectButton();				break;
				case BasicFBPicturePickerStates.FRIEND_SELECTED:		albumSelectedHandler();			break;
				case BasicFBPicturePickerStates.FRIENDS_LOADED: 		friendsLoadedHandler(); 		break;
				case BasicFBPicturePickerStates.FRIEND_ALBUM_LOADED: 	friendAlbumsLoadedHandler(); 	break;
			}
		}
		
		override protected function getButtonID($button:InteractiveObject):String {
			switch($button) {
				case friendsAlbumsButton:	return BasicFBPicturePickerStates.FRIENDS_ALBUMS_BTN;
			}
			return super.getButtonID($button);
		}
		
		protected function friendAlbumsLoadedHandler():void {
			if(!fbPPModel.isMyAlbums){
				addGallery(fbPPModel.friendAlbums);
			}
		}
		
		protected function friendsLoadedHandler():void {
			addGallery(fbPPModel.friends);
		}
		
		protected function friendPhotosLoadedHandler():void {
			addGallery(fbPPModel.friendphotos);
		}
		
		override protected function onGalleryThumbPress($event:ThumbnailEvent):void {
			super.onGalleryThumbPress($event);
			switch(_model.currentState) {
				case BasicFBPicturePickerStates.FRIEND_ALBUM_LOADED:	fbPPController.setSelectedAlbum($event);	break;
				case BasicFBPicturePickerStates.FRIEND_SELECTED:
					//				case BasicFBPicturePickerStates.FRIENDS_UID_LOADED:		
				case BasicFBPicturePickerStates.FRIENDS_LOADED: 		fbfPPController.setSelectedFriend($event);	break; // primer amigo selecto
			}
		}
		
		override protected function loadErrorHandler():void {
			super.loadErrorHandler();
			switch(_model.currentState) {
				case BasicFBPicturePickerStates.FRIEND_ALBUMS_ERROR: _model.setState(BasicFBPicturePickerStates.FRIENDS_LOADED); break;
			}
		}
	}
}
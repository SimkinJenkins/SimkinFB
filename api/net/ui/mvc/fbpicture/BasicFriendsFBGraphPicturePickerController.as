package net.ui.mvc.fbpicture {

	import com.facebook.graph.Facebook;
	import com.graphics.gallery.ThumbnailEvent;
	import com.ui.controllers.mvc.BasicFormStates;
	import com.ui.controllers.mvc.fbpicture.BasicFBPicturePickerStates;
	import com.ui.controllers.mvc.interfaces.IModel;
	
	import flash.events.Event;
	import flash.system.Security;
	
	import net.structures.AlbumData;
	import net.structures.FBUserData;
	import net.structures.PhotoData;

	public class BasicFriendsFBGraphPicturePickerController extends BasicFBGraphPicturePickerController {

		public function BasicFriendsFBGraphPicturePickerController($model:IModel) {
			super($model);
		}

		override public function clickHandler($ID:String):void {
			if($ID != BasicFormStates.ON_CANCEL_BTN && !testFBSession()) {
				return;
			}
			if($ID == BasicFormStates.ON_CANCEL_BTN){
				switch(_model.currentState){
					case BasicFBPicturePickerStates.FRIEND_ALBUM_LOADED:
					case BasicFBPicturePickerStates.ALBUM_SELECTED:
						if(fbPPModel.currentFriend){
							_model.setState(BasicFBPicturePickerStates.FRIENDS_ALBUMS_BTN);
							$ID = BasicFBPicturePickerStates.FRIENDS_ALBUMS_BTN;
						}else{
							super.clickHandler($ID);
						}
						break;
					case BasicFBPicturePickerStates.PHOTOS_DATA_LOADED:
					case BasicFBPicturePickerStates.PHOTO_SELECTED:
						if(fbPPModel.currentFriend) {
							_model.setState(BasicFBPicturePickerStates.FRIEND_ALBUM_LOADED);
							super.clickHandler(BasicFBPicturePickerStates.ALBUM_SELECTED);
							return;
						} else {
							_model.setState(BasicFBPicturePickerStates.MY_ALBUMS_BTN);
							super.clickHandler(BasicFBPicturePickerStates.MY_ALBUMS_BTN);
							return;
						}
						break;
					default:
						super.clickHandler($ID);
						break;
				}
			}
			switch($ID) {
				case BasicFBPicturePickerStates.FRIENDS_ALBUMS_BTN:					getFriendList();		break;
			}
			super.clickHandler($ID);
		}
		
		override protected function onSelectButtonClick():void {
			super.onSelectButtonClick();
			switch(fbPPModel.pickerState) {
				case BasicFBPicturePickerStates.FRIEND_PHOTOS_LOADED:	friendPhotosLoadedHandler(); 	break;
				case BasicFBPicturePickerStates.FRIEND_SELECTED:		getFriendAlbums();				break;
			}
		}
		
		public function setSelectedFriend($event:ThumbnailEvent):void {
			fbPPModel.currentFriend = $event.data as FBUserData;
			_model.setState(BasicFBPicturePickerStates.FRIEND_SELECTED);
			fbPPModel.setPicketState(BasicFBPicturePickerStates.FRIEND_SELECTED);
		}
		
		public function getFriendAlbumPhotos($event:ThumbnailEvent):void {
			fbPPModel.currentFriendAlbum = $event.data as ThumbnailAlbumDataGraph;
			_model.setState(BasicFBPicturePickerStates.FRIEND_ALBUM_SELECTED);
		}
		
		protected function friendAlbumPhotosContentLoaded($event:Event):void { //FacebookEvent):void {
			var photosArray:Array = new Array();
			fbPPModel.friendphotos = photosArray;
			_model.setState(BasicFBPicturePickerStates.FRIEND_PHOTOS_LOADED);
		}
		
		public function getFriendAlbums():void {
			if(_model.currentState != BasicFBPicturePickerStates.LOADING_ALBUMS) {
				_model.setState(BasicFBPicturePickerStates.LOADING_ALBUMS);
				Facebook.api("/" + fbPPModel.currentFriend.ID + "/albums", friendAlbumContentLoaded);
			}
		}
		
		protected function friendAlbumContentLoaded($result:Object, $fail:Object):void{
			if($result) {
				fbPPModel.friendAlbums = new Array();
				_currentCover = 0;
				fbPPModel.currentCover = 0;
				for(var i:uint = 0; i < $result.length; i++) {
					fbPPModel.friendAlbums.push(new AlbumData($result[i]));
				}
				if(fbPPModel.friendAlbums[_currentCover]){
					getFriendsAlbumCover(fbPPModel.friendAlbums[_currentCover]);
				}else{
					_model.setError("Tu amigo no permite ingresar a sus álbumes");
					_model.setState(BasicFBPicturePickerStates.FRIENDS_LOADED);
				}
			} else {
				_model.setError("Error al pedir los álbumes de un amigo");
				_model.setState(BasicFBPicturePickerStates.FRIENDS_LOADED);
			}
		}
		
		protected function getFriendsAlbumCover($data:AlbumData):void {
			if($data.coverPhoto) {
				Facebook.api($data.coverPhoto, onGetFriendsAlbumCover);
			} else {
				getNextCoverFriendsAlbum();
			}
		}
		
		protected function onGetFriendsAlbumCover($result:Object, $fail:Object):void {
			if($result) {
				(fbPPModel.friendAlbums[_currentCover] as AlbumData).coverDetail = new PhotoData($result);
				getNextCoverFriendsAlbum();
			} else {
				_model.setError("Error al pedir las portadas de los álbumes");
				_model.setState(BasicFBPicturePickerStates.FRIENDS_LOADED);
			}
		}
		
		protected function getNextCoverFriendsAlbum():void {
			if(_currentCover < fbPPModel.friendAlbums.length - 1 && !fbPPModel.isMyAlbums) {
				_currentCover++;
				fbPPModel.currentCover++;
				getFriendsAlbumCover(fbPPModel.friendAlbums[_currentCover]);
			} else {
				_model.setState(BasicFBPicturePickerStates.FRIEND_ALBUM_LOADED);
			}
		}
		
		public function getFriendList():void {
			fbPPModel.isMyAlbums = false;
			if(_model.currentState != BasicFBPicturePickerStates.FRIENDS_LOADING) {
				_model.setState(BasicFBPicturePickerStates.FRIENDS_LOADING);
				Facebook.api("/me/friends", onGetFriendsUidLoaded);
			}
		}
		
		protected function onGetFriendsUidLoaded($result:Object, $fail:Object):void {
			var friendsUidCleaned:Array = new Array();
			if($result) {
				for(var i:uint = 0; i < $result.length; i++) {
					friendsUidCleaned.push(new FBUserData($result[i]));
				}
			} else {
				_model.setError("Error al obtener la lista de amigos");
			}
			if(friendsUidCleaned) {
				fbPPModel.friends = friendsUidCleaned;
				_model.setState(BasicFBPicturePickerStates.FRIENDS_LOADED);
			} else {
				_model.setState(BasicFBPicturePickerStates.FRIENDS_LOADED_EMPTY);
			}
		}
		
		protected function friendsUidLoadedHandler():void {}
		
		protected function onGetInfoComplete($event:Event):void { //FacebookEvent):void {
			var friendsThumbnailList:Array = new Array();
			fbPPModel.friends = friendsThumbnailList;
			_model.setState(BasicFBPicturePickerStates.FRIENDS_LOADED);
		}
	}
}
package net.ui.mvc.fbpicture {
	
	import com.facebook.graph.Facebook;
	import com.graphics.gallery.ThumbnailEvent;
	import com.ui.controllers.mvc.BasicFormStates;
	import com.ui.controllers.mvc.controllers.BasicMVCFormController;
	import com.ui.controllers.mvc.fbpicture.BasicFBPicturePickerStates;
	import com.ui.controllers.mvc.interfaces.IFormController;
	import com.ui.controllers.mvc.interfaces.IModel;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.profiler.showRedrawRegions;
	import flash.system.Security;
	
	import net.core.EtniaFacebookGraph;
	import net.structures.AlbumData;
	import net.structures.PhotoData;
	import net.ui.mvc.fbpicture.FacebookGraphPhotoPickerModel;
	
	public class BasicFBGraphPicturePickerController extends BasicMVCFormController implements IFormController {
		
		protected function get fbPPModel():FacebookGraphPhotoPickerModel {
			return _model as FacebookGraphPhotoPickerModel;
		}
		
		public function BasicFBGraphPicturePickerController($model:IModel) {
			super($model);
		}
		
		override public function clickHandler($ID:String):void {
			if($ID != BasicFormStates.ON_CANCEL_BTN && !testFBSession()) {
				return;
			}
			switch($ID) {
				case BasicFBPicturePickerStates.MY_ALBUMS_BTN:		_model.setState(BasicFBPicturePickerStates.INIT);
																	getAlbums();			break;
				case BasicFBPicturePickerStates.SELECT_BTN:			onSelectButtonClick();	break;
				
				case BasicFBPicturePickerStates.INIT: 				initialize(); 			break;
				case BasicFBPicturePickerStates.ALBUM_SELECTED: 	getAlbumContent(); 		break;
				case BasicFBPicturePickerStates.PHOTO_SELECTED: 	setPhotoSelected();	 	break;
				case BasicFBPicturePickerStates.PHOTO_UPLOAD: 		uploadPhoto();	 		break;
				case BasicFBPicturePickerStates.TERMS:				toggleTerms();			break;
			}
			super.clickHandler($ID);
		}

		public function getAlbums($userID:String = null):void {
			fbPPModel.isMyAlbums = true;
			if(fbPPModel.albums) {
				fbPPModel.currentCover = 0;
				getAlbumCover(fbPPModel.albums[fbPPModel.currentCover]);
			} else {
				fbPPModel.currentFriend = null;
				if(_model.currentState != BasicFBPicturePickerStates.LOADING_ALBUMS) {
					fbPPModel.uid = EtniaFacebookGraph.getInstance().userData.id;
					Facebook.api("/me/albums", handleGetAlbumsResponse);
					_model.setState(BasicFBPicturePickerStates.LOADING_ALBUMS);
				}
			}
		}
		
		public function getNextCoverAlbum():void {
			if(fbPPModel.currentCover < fbPPModel.albums.length - 1 && fbPPModel.isMyAlbums) {
				fbPPModel.currentCover++;
				fbPPModel.currentRetry = 0;
				getCurrentCoverAlbum();
			}
		}

		protected function testFBSession():Boolean {
			return true;
		}
		
		protected function onSelectButtonClick():void {
			switch(fbPPModel.pickerState) {
				case BasicFBPicturePickerStates.ALBUM_SELECTED:			getSelectedAlbumPhotos();		break;
				case BasicFBPicturePickerStates.PHOTO_SELECTED: 		uploadPicture();				break;
			}
		}
		
		protected function toggleTerms():void {
			fbPPModel.terms = !fbPPModel.terms;
		}
		
		protected function friendPhotosLoadedHandler():void {
			trace("Esto como para que");
		}
		
		protected function uploadPicture():void {
			if(!fbPPModel.terms) {
				_model.setError(BasicFBPicturePickerStates.TERMS_ERROR);
				return;
			}
			_model.setState(BasicFormStates.FINISHING);
		}
		
		protected function getAlbumContent():void {
			_model.setState(BasicFBPicturePickerStates.ALBUM_SELECTED);
		}
		
		protected function setPhotoSelected():void {
			_model.setState(BasicFBPicturePickerStates.PHOTO_SELECTED);
		}
		
		protected function uploadPhoto():void {
			_model.setState(BasicFBPicturePickerStates.PHOTO_UPLOAD);
		}

		protected function handleGetAlbumsResponse($result:Object, $fail:Object):void{
			if($result) {
				fbPPModel.albums = new Array();
				fbPPModel.currentCover = 0;
				for(var i:uint = 0; i < $result.length; i++) {
					fbPPModel.albums.push(new AlbumData($result[i]));
				}
				getAlbumCover(fbPPModel.albums[fbPPModel.currentCover]);
			} else {
				_model.setError("Error al pedir los álbumes");
			}
		}
		
		protected function getAlbumCover($data:AlbumData):void {
			if($data.coverPhoto) {
				Facebook.api($data.coverPhoto, onGetAlbumCover);
			} else {
				getNextCoverAlbum();
			}
		}
		
		protected function onGetAlbumCover($result:Object, $fail:Object):void {
			if($result) {
				setCurrentCoverData($result);
			} else {
				if(fbPPModel.currentRetry < fbPPModel.retries) {
					fbPPModel.currentRetry++;
					getCurrentCoverAlbum();
				} else {
					getNextCoverAlbum();
//					_model.setError("Error al pedir las portadas de los álbumes");
				}
			}
		}

		protected function setCurrentCoverData($result:Object):void {
			(fbPPModel.albums[fbPPModel.currentCover] as AlbumData).coverDetail = new PhotoData($result);
			getNextCoverAlbum();
		}

		protected function getCurrentCoverAlbum():void {
			getAlbumCover(fbPPModel.albums[fbPPModel.currentCover]);
		}

		protected function onGetPhotosError($event:Event):void {//FacebookEvent):void {
			trace($event);
		}
		
		public function setSelectedAlbum($event:ThumbnailEvent):void {
			fbPPModel.currentAlbum = $event.data as AlbumData;
			_model.setState(BasicFBPicturePickerStates.ALBUM_SELECTED);
			fbPPModel.setPicketState(BasicFBPicturePickerStates.ALBUM_SELECTED);
		}
		
		public function setSelectedPhoto($event:ThumbnailEvent):void {
			fbPPModel.currentPhotoURL = $event.data.URL;
			_model.setState(BasicFBPicturePickerStates.PHOTO_SELECTED);
			fbPPModel.setPicketState(BasicFBPicturePickerStates.PHOTO_SELECTED);
		}
		
		public function getSelectedAlbumPhotos():void {
			if(_model.currentState != BasicFBPicturePickerStates.LOADING_ALBUMS) {
				Facebook.api(fbPPModel.currentAlbum.ID + "/photos", albumContentLoaded);
				_model.setState(BasicFBPicturePickerStates.LOADING_ALBUMS);			
			}
		}
		
		protected function albumContentLoaded($result:Object, $fail:Object):void {
			if($result) {
				var photosData:Array = new Array();
				for(var i:uint = 0; i < $result.length; i++) {
					photosData.push(new PhotoData($result[i]));
				}
				fbPPModel.photos = photosData;
			} else {
				_model.setError("Error al pedir las fotos del álbum seleccionado");
			}
		}

	}
}
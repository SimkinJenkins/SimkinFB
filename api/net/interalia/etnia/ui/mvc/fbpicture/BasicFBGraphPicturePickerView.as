package net.interalia.etnia.ui.mvc.fbpicture {
	import com.etnia.events.AlertEvent;
	import com.etnia.graphics.gallery.SimpleGallery;
	import com.etnia.graphics.gallery.ThumbnailEvent;
	import com.etnia.graphics.gallery.ThumbnailEventType;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.interalia.etnia.ui.mvc.interfaces.IController;
	import net.interalia.etnia.ui.mvc.interfaces.IModel;
	import net.interalia.etnia.ui.mvc.views.BasicFormView;
	
	
	public class BasicFBGraphPicturePickerView extends BasicFormView {
		
		protected var _isPhotoPickerAlbumsLoaded:Boolean;
		protected var _selectButton:InteractiveObject;
		protected var _addBtn:SimpleButton;
		protected var _cancelBtn:SimpleButton;
		protected var _myAlbumsButton:InteractiveObject;
		protected var _friendsAlbumsButton:InteractiveObject;
		
		protected var _gallery:SimpleGallery;
		
		protected var _loaderClass:Class = GraphicInfinitLoader;
		
		public function set loaderClass($class:Class):void {
			_loaderClass = $class;
		}
		
		protected function get selectButton():InteractiveObject {
			return _selectButton;
		}
		
		protected function get myAlbumsButton():InteractiveObject {
			return _myAlbumsButton
		}
		
		protected function get friendsAlbumsButton():InteractiveObject {
			return _friendsAlbumsButton
		}
		
		protected function get fbPPController():BasicFBGraphPicturePickerController {
			return _controller as BasicFBGraphPicturePickerController;
		}
		
		protected function get fbPPModel():FacebookGraphPhotoPickerModel {
			return _model as FacebookGraphPhotoPickerModel;
		}
		
		public function BasicFBGraphPicturePickerView($model:IModel, $controller:IController = null, $graphic:Sprite = null) {
			super($model, $controller, $graphic);
		}
		
		override public function destructor():void {
			buttonDestructor(myAlbumsButton);
			buttonDestructor(friendsAlbumsButton);
			buttonDestructor(selectButton);
			removeGalleries();
			super.destructor();
		} 
		
		override protected function initGraphic():void {
			super.initGraphic();
			_myAlbumsButton = getButton("de mis álbumes", 100, 100);
			_friendsAlbumsButton = getButton("de mis amigos", 250, 100);
			_cancelButton = getButton("Cancelar", 400, 130);
			_selectButton = getButton("Seleccionar", 400, 100, false);
		}
		
		override protected function stateUpdate($event:Event):void {
			super.stateUpdate($event);
			switch(_model.currentState) {
				case BasicFBPicturePickerStates.ALBUMS_LOADED:			albumsLoadedHandler(); 			break;
				case BasicFBPicturePickerStates.ALBUM_SELECTED:			showSelectButton();				break;
				case BasicFBPicturePickerStates.PHOTOS_DATA_LOADED:		onAlbumPhotosDataLoad();		break;
				case BasicFBPicturePickerStates.PHOTO_SELECTED: 		photoSelectedHandler(); 		break;
				case BasicFBPicturePickerStates.EXIT: 					photoPickerExit(); 				break;
			}
		}
		
		override protected function getButtonID($button:InteractiveObject):String {
			switch($button) {
				case myAlbumsButton:		return BasicFBPicturePickerStates.MY_ALBUMS_BTN;
				case selectButton:			return BasicFBPicturePickerStates.SELECT_BTN;
			}
			return super.getButtonID($button);
		}
		
		protected function albumsLoadedHandler():void {
			addGallery(fbPPModel.albums);
		}
		
		protected function onAlbumPhotosDataLoad():void {
			showSelectButton(false);
			addGallery(fbPPModel.photos);
		}
		
		protected function showSelectButton($add:Boolean = true):void {
			addElement(selectButton, $add);
		}
		
		protected function addGallery($data:Array):void {
			removeGalleries();
			var gallery:SimpleGallery = createGallery();
			addElement(gallery);
			addListener(gallery, SimpleGallery.ON_GALLERY_RENDER, onGalleryRender, true, true);
			addListener(gallery, SimpleGallery.ON_GALLERY_FULL_LOADED, onGalleryRender, true, true);
			addListener(gallery, ThumbnailEventType.ON_PRESS, onGalleryThumbPress);
			gallery.initializeGallery($data);
		}
		
		protected function onGalleryRender($event:Event):void {
			var gallery:SimpleGallery = $event.target as SimpleGallery;
			addListener(gallery, SimpleGallery.ON_GALLERY_RENDER, onGalleryRender, false);
			addListener(gallery, SimpleGallery.ON_GALLERY_FULL_LOADED, onGalleryRender, false);
			addElement(gallery);
		}
		
		protected function onGalleryThumbPress($event:ThumbnailEvent):void {
			switch(_model.currentState) {
				case BasicFBPicturePickerStates.ALBUM_SELECTED:	
				case BasicFBPicturePickerStates.ALBUMS_LOADED:			fbPPController.setSelectedAlbum($event);	break; // primer album selecto
				case BasicFBPicturePickerStates.PHOTOS_LOADED:
				case BasicFBPicturePickerStates.PHOTO_SELECTED:
				case BasicFBPicturePickerStates.PHOTOS_DATA_LOADED:		fbPPController.setSelectedPhoto($event);	break; // primer foto selecta despues de data
			}
		}
		
		protected function albumSelectedHandler():void {
			showSelectButton();
		}
		
		protected function photoSelectedHandler():void {
			showSelectButton();
		}
		
		protected function closeRefresh($event:MouseEvent):void {
			_model.setState(BasicFBPicturePickerStates.EXIT);
		}
		
		protected function photoPickerExit():void {
			initGraphic();
			dispatchEvent(new Event(BasicFBPicturePickerStates.EXIT));
		}
		
		protected function onCloseAlert($event:AlertEvent):void	{}
		
		protected function agreeButtonHandler($event:MouseEvent):void {
			var checkButton:MovieClip = ($event.currentTarget as MovieClip);
			if(checkButton.currentFrame == 2) {
				checkButton.gotoAndStop(1);
			} else {
				checkButton.gotoAndStop(2);	
			}
		}
		
		protected function createGallery():SimpleGallery {
			if(!_gallery) {
				_gallery = new SimpleGallery(-1, 10);
				_gallery.adjustImage = true;
				_gallery.visible = false;
			}
			return _gallery;
		}
		
		protected function removeGalleries():void {
			destructGallery(_gallery);
		}
		
		public function destructGallery($gallery:SimpleGallery):void {
			addListener($gallery, SimpleGallery.ON_GALLERY_RENDER, onGalleryRender, false);
			addListener($gallery, SimpleGallery.ON_GALLERY_FULL_LOADED, onGalleryRender, false);
			addListener($gallery, ThumbnailEventType.ON_PRESS, onGalleryThumbPress, false);
			addElement($gallery, false);
		}
		
		protected function removeAlbums():void {
			initGraphic();
		}
		
		protected function loadErrorHandler():void {
			addElement(_gallery, true);
			initGraphic();
			switch(_model.currentState) {
				case BasicFBPicturePickerStates.ALBUMS_LOAD_ERROR: _model.setState(BasicFBPicturePickerStates.ALBUMS_LOADED); break;
				case BasicFBPicturePickerStates.PHOTOS_LOAD_ERROR: _model.setState(BasicFBPicturePickerStates.PHOTOS_LOADED); break;
			}
		}
		
	}
}
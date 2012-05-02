package net.ui.mvc.userpicture {

	import com.ui.controllers.mvc.BasicFormStates;
	import com.ui.controllers.mvc.controllers.BasicMVCFormController;
	import com.ui.controllers.mvc.interfaces.IFormController;
	import com.ui.controllers.mvc.interfaces.IModel;
	import com.ui.controllers.mvc.userpicture.UserPicturePickerStates;
	import com.ui.controllers.mvc.webcam.BasicWebcamController;
	import com.utils.graphics.DisplayContainer;
	import com.utils.graphics.MainDisplayController;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	import net.ui.mvc.fbpicture.BasicFriendsFBGraphPicturePickerController;

	public class UserPicturePickerGraphController extends BasicMVCFormController implements IFormController {
		protected var _loader:Loader;
		protected var _fileRefControllerClass:Class = BasicFileReferenceControllerGraph;
		protected var _fbControllerClass:Class = BasicFriendsFBGraphPicturePickerController;
		
		public function set fileRefControllerClass ($value:Class):void {
			_fileRefControllerClass = $value;
		}
		
		public function set fbControllerClass ($value:Class):void {
			_fbControllerClass = $value;
		}
		
		protected function get modelUPP():UserPicturePickerGraphModel {
			return _model as UserPicturePickerGraphModel;
		}
		
		public function UserPicturePickerGraphController($model:IModel) {
			super($model);
		}
		
		override public function clickHandler($ID:String):void {
			super.clickHandler($ID);
			switch($ID) {
				case UserPicturePickerStates.FB_PICTURE_MODE:	Security.loadPolicyFile("http://a7.sphotos.ak.fbcdn.net/crossdomain.xml");
					setFBPicMode();						break;
				case UserPicturePickerStates.WEB_CAM_MODE:		setWebcamMode();					break;
				case UserPicturePickerStates.USER_FILE_MODE:	setUserFileMode();					break;
			}
			modelUPP.selectedType = $ID;
			_model.setState($ID);
		}
		
		protected function setFBPicMode():void {
			modelUPP.selectFileController = new _fbControllerClass(modelUPP.fbPicModel);
			addListener(modelUPP.fbPicModel, Event.CHANGE, onModelChange, true, true);
		}
		
		protected function setWebcamMode():void {
			modelUPP.selectFileController = new BasicWebcamController(modelUPP.webcamPicModel);
			addListener(modelUPP.webcamPicModel, Event.CHANGE, onModelChange, true, true);
		}
		
		protected function setUserFileMode():void {
			modelUPP.selectFileController = new _fileRefControllerClass(modelUPP.userFileModel);
			addListener(modelUPP.userFileModel, Event.CHANGE, onModelChange, true, true);
		}
		
		protected function onModelChange($event:Event):void {
			var model:IModel = $event.target as IModel;
			if(model.currentState == BasicFormStates.CANCELED || model.currentState == BasicFormStates.FINISHED) {
				addListener(model, Event.CHANGE, onModelChange, false);
				if(model.currentState == BasicFormStates.CANCELED) {
					modelUPP.selectFileController = null;
					_model.setState(UserPicturePickerStates.HOME);
				} else {
					onModelFinished(model);
				}
			}
		}
		
		protected function onModelFinished($model:IModel):void {
			switch(modelUPP.selectedType) {
				case UserPicturePickerStates.FB_PICTURE_MODE:	onFBMode();			return;
				case UserPicturePickerStates.WEB_CAM_MODE:		onWebCamMode();		break;	
				case UserPicturePickerStates.USER_FILE_MODE:
					if (modelUPP.userFileModel.file) {
						modelUPP.userImage = modelUPP.userFileModel.file;
						break;
					} else {
						loadImage(modelUPP.userFileModel.fileUpURL);
						return;
					}
			}
			_model.setState(BasicFormStates.FINISHED);
		}
		
		protected function onFBMode():void {
			loadImage(modelUPP.fbPicModel.currentPhotoURL);
		}
		
		protected function onWebCamMode():void {
			var image:Sprite = new Sprite();
			image.addChild(modelUPP.webcamPicModel.capturedImage);
			
			//			modelUPP.userImage = GraphicUtils.getClone(modelUPP.webcamPicModel.capturedImage);
			modelUPP.userImage = image;
		}
		
		protected function loadImage($imageURL:String):void {
			_model.setState(BasicFormStates.LOADING);
			if(!$imageURL) {
				return;
				throw new Error("FBPPController: No se puede cargar un $imageURL nulo");
			}
			var urlReq:URLRequest = new URLRequest($imageURL);
			var context: LoaderContext = new LoaderContext(true);
			_loader = new Loader();
			createLoadImageListeners();
			_loader.load(urlReq, context);
		}
		
		protected function createLoadImageListeners($create:Boolean = true):void {
			if(_loader) {
				addListener(_loader.contentLoaderInfo, Event.INIT, onLoadImage, $create);
				addListener(_loader.contentLoaderInfo, ProgressEvent.PROGRESS, onProgress, $create);
				addListener(_loader.contentLoaderInfo, IOErrorEvent.IO_ERROR, onLoadImageIOError, $create);
			}
		}
		
		protected function onLoadImage($event:Event):void {
			createLoadImageListeners(false);
			switch(modelUPP.selectedType) {
				case UserPicturePickerStates.FB_PICTURE_MODE:	onFBModeFinish();			break;
				case UserPicturePickerStates.USER_FILE_MODE:	onUserFileModeFinish();		break;
			}
			_model.setState(BasicFormStates.FINISHED);
		}
		
		protected function onFBModeFinish():void {
			modelUPP.userImage = modelUPP.fbPicModel.selectedPhoto = _loader.content;
		}
		
		protected function onUserFileModeFinish():void {
			modelUPP.userImage = modelUPP.userFileModel.selectedPhoto = _loader.content;			
		}
		
		protected function onProgress($event: ProgressEvent):void {
			//			trace($event.bytesLoaded + " ::: " + $event.bytesTotal);
		}
		
		protected function onLoadImageIOError($event: IOErrorEvent):void {
			createLoadImageListeners(false);
		}
/*
		protected function get mainContainer():DisplayContainer {
			return MainDisplayController.getInstance().displayContainer.getStoredContainer("mainContainer");
		}
*/
	}
}
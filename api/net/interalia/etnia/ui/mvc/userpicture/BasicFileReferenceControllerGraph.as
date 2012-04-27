package net.interalia.etnia.ui.mvc.userpicture {
	import com.etnia.net.DataSenderFormat;
	import com.etnia.net.EtniaDataSender;
	import com.etnia.net.EtniaServerResponse;
	
	import flash.display.Loader;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	//import net.etnia.EtniaFacebook;
	import net.interalia.etnia.ui.mvc.BasicFormStates;
	import net.interalia.etnia.ui.mvc.controllers.BasicMVCFormController;
	import net.interalia.etnia.ui.mvc.interfaces.IFormController;
	import net.interalia.etnia.ui.mvc.interfaces.IModel;
	import net.interalia.etnia.ui.mvc.userpicture.interfaces.IFileReferenceModel;
	
	public class BasicFileReferenceControllerGraph extends BasicMVCFormController implements IFormController {
		
		protected var _fileFilter:FileFilter;
		protected var _fileReference:FileReference;
		protected var _filedataName:String;
		protected var _loader:Loader;
		
		public function set fileFilter($ffilter:FileFilter):void {
			_fileFilter = $ffilter;
		}
		
		protected function get fileReferenceModel():IFileReferenceModel {
			return _model as IFileReferenceModel;
		}
		
		public function BasicFileReferenceControllerGraph($model:IModel) {
			_fileReference = null;
			_fileFilter = new FileFilter("Images", "*.jpg;*.png");
			super($model);
		}
		
		override public function clickHandler($ID:String):void {
			switch($ID) {
				case BasicFileReferenceStates.ADD:		addClickHandler();		break;
				case BasicFileReferenceStates.SELECT:	selectClickHandler();	break;
				case BasicFileReferenceStates.CHANGE:	changeClickHandler();	break;
				case BasicFileReferenceStates.TERMS:	toggleTerms();			break;
			}
			super.clickHandler($ID);
		}
		
		override public function destructor():void {
			super.destructor();
			configureListeners(_fileReference, false);
			fileReferenceModel.terms = false;
		}
		
		protected function toggleTerms():void {
			fileReferenceModel.terms = !fileReferenceModel.terms;
		}
		
		protected function addClickHandler():void {
			if(!fileReferenceModel.terms) {
				_model.setError(BasicFileReferenceStates.TERMS_ERROR);
				return;
			}
			try {
				
				var vars:URLVariables = new URLVariables();
				//vars.usuario = EtniaFacebook.getInstance().user.uid;
				var request:URLRequest = new URLRequest(fileReferenceModel.serverUploadURL);
				request.method = URLRequestMethod.POST;
				request.data = vars;
				
				//_fileReference.upload(request, fileReferenceModel.serverUploadFilename);
				// Fanta
				_fileReference.load(); 
				_model.setState(BasicFileReferenceStates.LOADING_FILE);
			} catch ($error:Error) {
				trace($error);
				_model.setError(BasicFileReferenceStates.UPLOAD_ERROR, $error.toString());
			}
		}
		
		protected function selectClickHandler():void {
			createFileReference(_fileFilter);
		}
		
		protected function changeClickHandler():void {
			_fileReference.browse(_fileFilter ? [_fileFilter] : null);
		}
		
		protected function createFileReference($filter:FileFilter):void {
			if(_fileReference) {
				configureListeners(_fileReference, false);
				_fileReference = null;
			}
			_fileReference = new FileReference();
			configureListeners(_fileReference);
			_fileReference.browse($filter ? [$filter] : null);
		}
		
		protected function configureListeners($dispatcher:FileReference, $enabled:Boolean = true):void {
			addListener($dispatcher, Event.SELECT, selectHandler, $enabled);
			addListener($dispatcher, Event.CANCEL, cancelHandler, $enabled);
			addListener($dispatcher, Event.COMPLETE, completeHandler, $enabled);
			addListener($dispatcher, DataEvent.UPLOAD_COMPLETE_DATA, completeDataHandler, $enabled);
			addListener($dispatcher, ProgressEvent.PROGRESS, progressHandler, $enabled);
			addListener($dispatcher, IOErrorEvent.IO_ERROR, ioErrorHandler, $enabled);
			addListener($dispatcher, SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, $enabled);
		}
		
		protected function selectHandler($event:Event):void {
			fileReferenceModel.filename = _fileReference.name;
			_model.setState(BasicFileReferenceStates.FILE_SELECTED);
		}
		
		protected function cancelHandler($event:Event):void {
			_fileReference = null;
		}
		
		protected function completeHandler($event:Event):void {
			_model.setState(BasicFileReferenceStates.PROCESING_FILE);
			try {
				if($event.target.data) {
					_loader = new Loader();
					addListener(_loader.contentLoaderInfo, Event.COMPLETE, onGetBitmapData);
					_loader.loadBytes($event.target.data);	
				}
			} catch($error: Error) {
				trace($error);
			}
		}
		
		protected function onGetBitmapData($event:Event):void {
			addListener(_loader.contentLoaderInfo, Event.COMPLETE, onGetBitmapData, false);
			fileReferenceModel.file = $event.target.content;
			_model.setState(BasicFormStates.FINISHING);
			_fileReference = null;
			_loader = null;
		}
		
		protected function completeDataHandler($event:DataEvent):void {
			var response:EtniaServerResponse;
			try {
				response = EtniaDataSender.getServerResponse($event.data, DataSenderFormat.XML_DATA_MANAGER, EtniaDataSender.DEFULT_INITIAL_TAG);
			} catch($error:Error) {
				response = EtniaDataSender.getJSONServerResponse($event.data);
			}
			if(response["error"] != null || response["errors"] != null) {
				_model.setError(BasicFileReferenceStates.UPLOAD_ERROR, response["error"] ? response["error"] : response["errors"]);
				return;
			}
			fileReferenceModel.fileUpURL = response["url"];
			_model.setState(BasicFormStates.FINISHING);
			_fileReference = null;
			
		}
		
		//Ya solo falta ir seteando el progreso//
		protected function progressHandler($event:ProgressEvent):void {
			//			addLoader("enviando " + Math.round($event.bytesLoaded / $event.bytesTotal * 100) + "%", Math.round($event.bytesLoaded / $event.bytesTotal * 100));
		}
		
		protected function ioErrorHandler($event:IOErrorEvent):void {
			configureListeners($event.target as FileReference, false);
			_model.setError(IOErrorEvent.IO_ERROR);
		}
		
		protected function securityErrorHandler($event:SecurityErrorEvent):void {
			configureListeners($event.target as FileReference, false);
			_model.setError(SecurityErrorEvent.SECURITY_ERROR);
		}
		
	}
}
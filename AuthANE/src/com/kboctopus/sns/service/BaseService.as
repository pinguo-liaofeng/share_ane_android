package com.kboctopus.sns.service
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	
	internal class BaseService implements IService
	{
		protected var result:Function;
		protected var error:Function;
		
		protected var appId:String;
		protected var appKey:String;
		protected var appSecret:String;
		protected var redirectUri:String;
		protected var token:String="";
		
		protected var upldr:URLLoader;
		
		public function BaseService()
		{
			this.upldr = new URLLoader();
			this.upldr.addEventListener(Event.COMPLETE, uploadResultHandler);
			this.upldr.addEventListener(IOErrorEvent.IO_ERROR, uploadErrorHandler);
			this.upldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadErrorHandler);
		}
		
		
		
		public function init(appid:String="", appKey:String="", appSecret:String="", redirectUri:String=""):void
		{
			this.appId = appid;
			this.appKey = appKey;
			this.appSecret = appSecret;
			this.redirectUri = redirectUri;
		}
		
		
		
		
		
		public function handlerAuthBack(result:String):void
		{
			this.token = result;
		}
		
		
		
		
		
		/**
		 * 分享带图微博 
		 * @param content
		 * @param img
		 * @param result
		 * @param error
		 * 
		 */		
		public function share(content:String, img:ByteArray, result:Function, error:Function):void
		{
			this.result = result;
			this.error = error;
		}
		
		
		
		
		public function hasAuth():Boolean
		{
			return token != "";
		}
		
		
		
		
		/**
		 * 上传发生IO或者安全错误 
		 * @param e
		 * 
		 */		
		protected function uploadErrorHandler(e:Event):void
		{
			if(this.error != null)
			{
				this.error(e.type);
				this.error = null;
			}
		}
		
		
		
		
		/**
		 * 上传结果, 注意这里不一定是上传成功！ 
		 * @param event
		 * 
		 */		
		protected function uploadResultHandler(event:Event):void
		{
			if(this.result != null)
			{
				this.result(this.upldr.data);
				this.result = null;
			}
		}
	}
}
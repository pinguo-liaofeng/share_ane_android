package com.kboctopus.sns
{
	import com.kboctopus.sns.constant.ServiceType;
	import com.kboctopus.sns.service.IService;
	import com.kboctopus.sns.service.SinaService;
	import com.kboctopus.sns.service.TencentService;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ServiceManager
	{
		private static var _ins:ServiceManager;
		private var authANE:AuthService;  //授权ane
		private var serviceDic:Dictionary;
		
		private var authSucess:Function;
		private var currentAuthServiceType:String;
		
		public function ServiceManager(authANE:AuthService)
		{
			if(null == authANE)
			{
				throw new IllegalOperationError("please use ins() to get the instance!");
			}
			this.authANE = authANE;
			this.serviceDic = new Dictionary();
		}
		
		
		
		/**
		 * 单例 
		 * @return 
		 * 
		 */		
		public static function ins():ServiceManager
		{
			if(null == _ins)
			{
				_ins = new ServiceManager(new AuthService());
			}
			return _ins;
		}
		
		
		
		/**
		 * 设置平台数据
		 */		
		public function initConfig(platForm:String, appid:String="", appKey:String="", appSecret:String="", redirectUri:String=""):ServiceManager
		{
			authANE.initConfig(platForm, appid, appKey, appSecret, redirectUri);
			getService(platForm).init(appid, appKey, appSecret, redirectUri);
			return this;
		}
		
		
		
		/**
		 *  调用ane授权
		 * param sucess
		 * 
		 */		
		public function auth(platForm:String, sucess:Function=null):void
		{
			this.authSucess = sucess;
			this.currentAuthServiceType = platForm;
			authANE.auth(platForm, authBackHandler);
		}
		
		
		
		
		/**
		 * 分享带图微博 
		 * @param platForm
		 * @param content
		 * @param img
		 * @param result
		 * @param error
		 * 
		 */		
		public function share(platForm:String, content:String, img:ByteArray, result:Function, error:Function):void
		{
			getService(this.currentAuthServiceType).share(content, img, result, error);
		}
		
		
		
		
		/**
		 * 授权与分享一体化 
		 * @param platForm
		 * @param content
		 * @param img
		 * @param result
		 * @param error
		 * 
		 */		
		public function authAndShare(platForm:String, content:String, img:ByteArray, result:Function, error:Function):void
		{
			this.currentAuthServiceType = platForm;
			
			if(getService(this.currentAuthServiceType).hasAuth())
			{
				this.share(platForm, content, img, result, error);
			}
			else
			{
				authANE.auth(platForm, continueShare);
			}
			
			function continueShare(result:String):void
			{
				getService(currentAuthServiceType).handlerAuthBack(result);
				this.share(currentAuthServiceType, content, img, result, error);
			}
		}
		
		
		
		
		
		/**
		 * 得到token的处理 
		 * @param token
		 * 
		 */		
		private function authBackHandler(result:String):void
		{
			getService(this.currentAuthServiceType).handlerAuthBack(result);
			if(this.authSucess != null)
			{
				this.authSucess(result);
				this.authSucess = null;
			}
		}
		
		
		
		/**
		 * 获取服务类, 每个类只实例化一次，且在用到的时候才实例化 
		 * @param name
		 * @return 
		 * 
		 */		
		private function getService(name:String):IService
		{
			if(this.serviceDic[name] == null)
			{
				switch(name)
				{
					case ServiceType.TENCENT:
						this.serviceDic[name] = new TencentService();
						break;
					
					
					case ServiceType.SINA:
						this.serviceDic[name] = new SinaService();
						break;
				}
			}
			return this.serviceDic[name];
		}
	}
}






/**
 * 授权ane 
 * @author LiaoFeng
 * 
 */
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

class AuthService
{
	private var snsContext:ExtensionContext;
	private var sucess:Function;
	
	public function AuthService()
	{
		snsContext = ExtensionContext.createExtensionContext("com.kboctopus.sns.SnsExtension", "");
		snsContext.addEventListener(StatusEvent.STATUS, onStatus);
	}
	
	
	
	protected function onStatus(event:StatusEvent):void
	{
		switch(event.code)
		{
			case "getTokenComplete":
				if(sucess != null)
				{
					sucess(event.level);
				}
				break;
		}
	}		
	
	/**
	 * 设置平台配置信息 
	 * @param platForm
	 * @param appid
	 * @param appKey
	 * @param appSecret
	 * @param redirectUri
	 * @return 
	 * 
	 */		
	public function initConfig(platForm:String, appid:String="", appKey:String="", appSecret:String="", redirectUri:String=""):void
	{
		snsContext.call("initConfig", platForm, appid, appKey, appSecret, redirectUri);
	}
	
	
	/**
	 * 授权 
	 * @param platForm
	 * @param sucess
	 * 
	 */	
	public function auth(platForm:String, sucess:Function):void
	{
		this.sucess = sucess;
		snsContext.call("auth", platForm);
	}
	
}
package com.kboctopus.sns.service
{
	import flash.utils.ByteArray;

	public interface IService
	{
		function init(appid:String="", appKey:String="", appSecret:String="", redirectUri:String=""):void;
		function share(content:String, img:ByteArray, result:Function, error:Function):void;
		function hasAuth():Boolean;
		function handlerAuthBack(result:String):void;
	}
}
package com.kboctopus.sns.service;

public interface ISNSService 
{
	void init(String appId, String appKey, String appSecret, String redirectUri);
	void auth();
	void share(String msg, String localPicPath, boolean slient);
	void authAndShare(String msg, String localPicPath, boolean slient);
	void handlerCallbackURL(String url);
}

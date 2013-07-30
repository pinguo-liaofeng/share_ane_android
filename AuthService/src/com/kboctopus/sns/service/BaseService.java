package com.kboctopus.sns.service;

import com.adobe.fre.FREContext;

/***
 * 
 * @author kboctopus
 *
 */
public class BaseService implements ISNSService {
	protected String appId;
	protected String appKey;
	protected String appSecret;
	protected String redirectUri;
	protected String authUrl;
	protected String token="";
	
	protected FREContext cnt = null;
	
	public BaseService(FREContext cnt)
	{
		this.cnt = cnt;
	}
	
	
	
	@Override
	public void init(String appId, String appKey, String appSecret, String redirectUri) {
		this.appId = appId;
		this.appKey = appKey;
		this.appSecret = appSecret;
		this.redirectUri = redirectUri;
	}

	
	
	@Override
	public void auth() {
	}

	
	
	
	@Override
	public void share(String msg, String localPicPath, boolean slient) {
		// TODO Auto-generated method stub

	}

	
	
	
	@Override
	public void authAndShare(String msg, String localPicPath, boolean slient) {
		// TODO Auto-generated method stub

	}
	
	
	
	
	@Override
	public void handlerCallbackURL(String url){
	}

}

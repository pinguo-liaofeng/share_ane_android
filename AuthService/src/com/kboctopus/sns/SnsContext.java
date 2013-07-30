package com.kboctopus.sns;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.kboctopus.sns.function.AuthFunction;
import com.kboctopus.sns.function.InitConfigFunction;
import com.kboctopus.sns.service.SNSServiceFactory;


public class SnsContext extends FREContext 
{
	public SnsContext()
	{
		SNSServiceFactory.cnt = this;
	}
	
	
	@Override
	public void dispose() 
	{
	}

	@Override
	public Map<String, FREFunction> getFunctions() 
	{
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		
		functionMap.put("initConfig", new InitConfigFunction());
		functionMap.put("auth", new AuthFunction());
		
		return functionMap;
	}
}

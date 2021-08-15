package com.xiaolanhe.crm.utils;

/**
 * @author xiaolanhe
 * @create 2021-08-08 19:40
 */

// 为 业务 动态创建代理类，处理事务
public class ServiceFactory {
    public static Object getService(Object service)
    {
        return new TransactionInvocationHandler(service).getProxy();
    }
}



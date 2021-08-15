package com.xiaolanhe.crm.utils;

import org.apache.ibatis.session.SqlSession;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
 * @author xiaolanhe
 * @create 2021-08-08 19:23
 */

// 将事务从业务层抽取出来，并为事务形成一个代理类

public class TransactionInvocationHandler implements InvocationHandler {

    private Object target; // 需要动态代理的目标

    public TransactionInvocationHandler(Object target) {
        this.target = target;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable{
        SqlSession session = null;
        Object result = null;

        try {
            session = SqlSessionUtil.getSqlSession();
            result = method.invoke(target,args);
            session.commit();
        } catch (Exception e) {
            session.rollback();
            e.printStackTrace();

            // 处理的是什么异常，需要继续往上抛(很重要)，给回被代理的对象
            throw e.getCause();

        }finally{
            SqlSessionUtil.close(session);
        }
        return result;
    }

    public Object getProxy()
    {
        return Proxy.newProxyInstance(target.getClass().getClassLoader(),target.getClass().getInterfaces(),this);
    }
}



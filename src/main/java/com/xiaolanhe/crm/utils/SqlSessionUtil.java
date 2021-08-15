package com.xiaolanhe.crm.utils;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;

/**
 * @author xiaolanhe
 * @create 2021-08-08 18:59
 */
public class SqlSessionUtil {

    public SqlSessionUtil() {
    }

    private static SqlSessionFactory factory;

    static{
        String resource = "mybatis-config.xml";
        InputStream inputStream = null;
        try {
            inputStream = Resources.getResourceAsStream(resource);
        } catch (IOException e) {
            e.printStackTrace();
        }
        factory = new SqlSessionFactoryBuilder().build(inputStream);
    }

    private static ThreadLocal<SqlSession> pool = new ThreadLocal<SqlSession>();

    // 从池子里取出一个SqlSession，若池子里面没有则创建一个并放入池子里
    public static SqlSession getSqlSession()
    {
        SqlSession sqlSession = pool.get();
        if(sqlSession == null){
            sqlSession = factory.openSession();
            pool.set(sqlSession);
        }
        return sqlSession;
    }

    // 关闭SqlSession，并从池子中移除
    public static void close(SqlSession sqlSession)
    {
        if(sqlSession != null){
            sqlSession.close();
            pool.remove();
        }
    }
}



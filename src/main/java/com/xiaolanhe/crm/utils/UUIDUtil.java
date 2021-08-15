package com.xiaolanhe.crm.utils;

import java.util.UUID;

/**
 * @author xiaolanhe
 * @create 2021-08-08 19:42
 */
public class UUIDUtil {
    public static String getUUID()
    {
        return UUID.randomUUID().toString().replaceAll("-","");
    }
}



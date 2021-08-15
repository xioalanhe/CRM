package com.xiaolanhe.crm.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author xiaolanhe
 * @create 2021-08-08 18:37
 */
public class DateTimeUtil {

    public static String getCurTime(){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date(); // 注意这里面使用util下的Date
        String dateStr = simpleDateFormat.format(date);
        return dateStr;
    }
}



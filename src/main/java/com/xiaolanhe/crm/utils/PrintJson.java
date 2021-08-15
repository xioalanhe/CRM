package com.xiaolanhe.crm.utils;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * @author xiaolanhe
 * @create 2021-08-08 18:49
 */
public class PrintJson {


    public static void printJsonFlag(HttpServletResponse response,boolean flag)
    {
        Map<String,Boolean> map = new HashMap<String,Boolean>();
        map.put("success",flag);
        ObjectMapper om = new ObjectMapper();
        try {
            String json = om.writeValueAsString(map);
            response.getWriter().print(json);
        } catch (JsonGenerationException e) {
            e.printStackTrace();
        } catch (JsonMappingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    // 将对象解析为JSON串
    public static void printJson(HttpServletResponse response, Object obj)
    {
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            String json = objectMapper.writeValueAsString(obj);
            response.getWriter().print(json);
        }  catch (JsonGenerationException e) {
            e.printStackTrace();
        } catch (JsonMappingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}



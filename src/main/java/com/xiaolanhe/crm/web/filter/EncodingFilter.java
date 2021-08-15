package com.xiaolanhe.crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

/**
 * @author xiaolanhe
 * @create 2021-08-08 15:43
 */
public class EncodingFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void destroy() {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("进入到过滤字符编码的过滤器");

        // 过滤post请求中文参数乱码
        request.setCharacterEncoding("UTF-8");

        // 过滤响应流响应中文乱码问题
        response.setContentType("text/html;charset=utf-8");

        //放行
        filterChain.doFilter(request,response);
    }

}



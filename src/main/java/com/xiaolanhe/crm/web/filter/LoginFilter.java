package com.xiaolanhe.crm.web.filter;

import com.xiaolanhe.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * @author xiaolanhe
 * @create 2021-08-10 18:32
 */
public class LoginFilter implements Filter {
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        System.out.println("进入到验证有没有登录过的过滤器");
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        String path = request.getServletPath();
        // 不应该被拦截的资源，自动放行
        if("/login.jsp".equals(path) || "/settings/user/login.do".equals(path))
        {
            chain.doFilter(req,resp);
        }else{
            HttpSession session = request.getSession(false);
            //User user = (User)session.getAttribute("user");
            // 如果session为空，说明没有登录过
            if(null == session){

                // 重定向到登录页

                /*
                 *  ${pageContext.request.contextPath}  /项目名
                 * */
                // 将路径写活
                response.sendRedirect(request.getContextPath()+"/login.jsp");

            }else{
                chain.doFilter(req,resp);
            }
        }



    }

    public void init(FilterConfig config) throws ServletException {

    }

}

package com.xiaolanhe.crm.settings.web.controller;

import com.xiaolanhe.crm.exception.LoginException;
import com.xiaolanhe.crm.settings.domain.User;
import com.xiaolanhe.crm.settings.service.UserService;
import com.xiaolanhe.crm.settings.service.impl.UserServiceImpl;
import com.xiaolanhe.crm.utils.MD5Util;
import com.xiaolanhe.crm.utils.PrintJson;
import com.xiaolanhe.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * @author xiaolanhe
 * @create 2021-08-09 19:16
 */
public class UserController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到用户控制器");

        String path = request.getServletPath();

        if("/settings/user/login.do".equals(path)){
            login(request,response);
        }
    }

    // 验证登录操作
    private void login(HttpServletRequest request, HttpServletResponse response) {
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");

        // 将密码转为MD5的密文形式
        loginPwd = MD5Util.getMD5(loginPwd);
        // 接收浏览器端的ip地址
        String ip = request.getRemoteAddr();
        System.out.println("--------------ip= " + ip);

        // 未来业务层的开发，统一使用代理类形态的接口对象来处理事务
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        try {
            User user = userService.login(loginAct, loginPwd, ip);
            HttpSession session = request.getSession();
            session.setAttribute("user",user);
            // 如果程序可以执行到此处，说明业务层没有向controller抛出任何的异常
            // 表示登录成功
            PrintJson.printJsonFlag(response,true);

        } catch (Exception e) {
            // 登录失败
            // 说明业务层验证登录失败，向controller抛出了异常
            e.printStackTrace();
            String message = e.getMessage();
            /*
             controller 需要为ajax提供多项信息
             有两种手段可以处理：
                1. 将多项信息打包成为map，将map解析为json串
                2. 创建一个 vo
                    private boolean success;
                    private String message;
                  如果对于展现的信息将来还会大量的使用，可以创建一个 vo 类，方便使用
                  如果对于展现的信息的使用不多，使用map就行
            * */
            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success",false);
            map.put("msg",message);
            PrintJson.printJson(response,map);
        }


    }
}

package com.xiaolanhe.crm.workbench.web.controller;

import com.xiaolanhe.crm.settings.domain.User;
import com.xiaolanhe.crm.settings.service.UserService;
import com.xiaolanhe.crm.settings.service.impl.UserServiceImpl;
import com.xiaolanhe.crm.utils.DateTimeUtil;
import com.xiaolanhe.crm.utils.PrintJson;
import com.xiaolanhe.crm.utils.ServiceFactory;
import com.xiaolanhe.crm.utils.UUIDUtil;
import com.xiaolanhe.crm.vo.PaginationVo;
import com.xiaolanhe.crm.workbench.domain.Activity;
import com.xiaolanhe.crm.workbench.service.ActivityService;
import com.xiaolanhe.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author xiaolanhe
 * @create 2021-08-11 19:02
 */
public class ActivityController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        System.out.println("进入到市场活动控制器");

        String path = req.getServletPath();

        if("/workbench/activity/getUserList.do".equals(path)){
            getUserList(req,resp);
        }else if("/workbench/activity/save.do".equals(path)){
            save(req,resp);
        }else if("/workbench/activity/pageList.do".equals(path)){
            pageList(req,resp);
        }else if("/workbench/activity/delete.do".equals(path)){
            delete(req,resp);
        }
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp) {

        System.out.println("进入到删除列表");

        String[] ids = req.getParameterValues("id");

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Boolean flag = activityService.delete(ids);

        PrintJson.printJsonFlag(resp,flag);
    }

    private void pageList(HttpServletRequest req, HttpServletResponse resp) {

        System.out.println("进入到查询市场活动信息的列表");

        String name = req.getParameter("name");
        String owner = req.getParameter("owner");
        String startDate = req.getParameter("startDate");
        String endDate = req.getParameter("endDate");

        String pageNoStr = req.getParameter("pageNo");
        int pageNo = Integer.valueOf(pageNoStr);

        // 每页展现的记录数
        String pageSizeStr = req.getParameter("pageSize");
        int pageSize = Integer.valueOf(pageSizeStr);

        // 计算略过的记录数
        int skipCount = (pageNo-1)*pageSize;

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        /*
        * 前端需要的信息 ：
        *           信息列表
        *           查询的总条数
        * */
        PaginationVo<Activity> vo =  activityService.pageList(map);
        PrintJson.printJson(resp,vo);
    }

    private void save(HttpServletRequest req, HttpServletResponse resp) {
        System.out.println("执行市场活动添加操作");
        String id = UUIDUtil.getUUID();
        String owner = req.getParameter("owner");
        String name = req.getParameter("name");
        String startDate = req.getParameter("startDate");
        String endDate = req.getParameter("endDate");
        String cost = req.getParameter("cost");
        String description = req.getParameter("description");

        // 创建时间：当前系统时间
        String createTime = DateTimeUtil.getCurTime();
        //创建人 ：当前登录用户
        String createBy = ((User)req.getSession().getAttribute("user")).getName();

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        Activity activity = new Activity();
        activity.setId(id);
        activity.setCost(cost);
        activity.setCreateBy(createBy);
        activity.setCreateTime(createTime);
        activity.setDescription(description);
        activity.setName(name);
        activity.setOwner(owner);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        boolean flag = activityService.save(activity);
        PrintJson.printJsonFlag(resp,flag);

    }

    private void getUserList(HttpServletRequest req, HttpServletResponse resp) {

        System.out.println("取得用户信息列表");

        UserService userService = (UserService)ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();

        PrintJson.printJson(resp,userList);
    }
}

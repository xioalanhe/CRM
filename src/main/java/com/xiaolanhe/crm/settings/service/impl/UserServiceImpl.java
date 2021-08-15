package com.xiaolanhe.crm.settings.service.impl;

import com.xiaolanhe.crm.exception.LoginException;
import com.xiaolanhe.crm.settings.dao.UserDao;
import com.xiaolanhe.crm.settings.domain.User;
import com.xiaolanhe.crm.settings.service.UserService;
import com.xiaolanhe.crm.utils.DateTimeUtil;
import com.xiaolanhe.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author xiaolanhe
 * @create 2021-08-09 19:43
 */
public class UserServiceImpl implements UserService {

    // 由 mybatis 创建 UsrDao的实现类
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String,String> map = new HashMap<String,String>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userDao.login(map);

        if(null == user){
            throw new LoginException("账号密码错误");
        }

        // 继续验证 失效时间，允许ip ，锁定状态
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getCurTime();
        int compare = currentTime.compareTo(expireTime);
        if(compare > 0){
            throw new LoginException("账号已经失效");
        }

        String lockState = user.getLockState();
        if("0".equals(lockState))
        {
            throw new LoginException("账号已经被锁定，请联系管理员");
        }

        String allowIps = user.getAllowIps();
        if(!allowIps.contains(ip)){
            throw new LoginException("ip地址受限，请联系管理员");
        }

        return user;

    }

    @Override
    public List<User> getUserList() {
        List<User> userList = userDao.getUserList();
        return userList;
    }
}



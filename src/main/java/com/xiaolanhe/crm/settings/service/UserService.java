package com.xiaolanhe.crm.settings.service;

import com.xiaolanhe.crm.exception.LoginException;
import com.xiaolanhe.crm.settings.domain.User;

import java.util.List;

/**
 * @author xiaolanhe
 * @create 2021-08-09 19:42
 */
public interface UserService {

    User login(String loginAct,String loginPwd,String ip) throws LoginException;

    List<User> getUserList();
}

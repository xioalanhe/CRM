package com.xiaolanhe.crm.settings.dao;

import com.xiaolanhe.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

/**
 * @author xiaolanhe
 * @create 2021-08-09 20:05
 */
public interface UserDao {

    User login(Map<String,String> map);

    List<User> getUserList();
}



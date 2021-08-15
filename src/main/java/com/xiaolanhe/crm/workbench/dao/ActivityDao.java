package com.xiaolanhe.crm.workbench.dao;

import com.xiaolanhe.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * @author xiaolanhe
 * @create 2021-08-11 19:29
 */
public interface ActivityDao {
    int save(Activity activity);

    int getTotalByCondition(Map<String, Object> map);

    List<Activity> getActivityListByCondition(Map<String, Object> map);

    int delete(String[] ids);
}

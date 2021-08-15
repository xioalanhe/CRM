package com.xiaolanhe.crm.workbench.service;

import com.xiaolanhe.crm.vo.PaginationVo;
import com.xiaolanhe.crm.workbench.domain.Activity;

import java.util.Map;

/**
 * @author xiaolanhe
 * @create 2021-08-11 19:26
 */
public interface ActivityService {
    Boolean save(Activity activity);

    PaginationVo<Activity> pageList(Map<String, Object> map);

    Boolean delete(String[] ids);
}

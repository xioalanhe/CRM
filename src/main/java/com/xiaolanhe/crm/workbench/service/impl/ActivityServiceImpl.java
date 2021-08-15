package com.xiaolanhe.crm.workbench.service.impl;

import com.xiaolanhe.crm.utils.SqlSessionUtil;
import com.xiaolanhe.crm.vo.PaginationVo;
import com.xiaolanhe.crm.workbench.dao.ActivityDao;
import com.xiaolanhe.crm.workbench.dao.ActivityRemarkDao;
import com.xiaolanhe.crm.workbench.domain.Activity;
import com.xiaolanhe.crm.workbench.service.ActivityService;

import java.util.List;
import java.util.Map;

/**
 * @author xiaolanhe
 * @create 2021-08-11 19:27
 */
public class ActivityServiceImpl implements ActivityService {

    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao remarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);

    @Override
    public Boolean save(Activity activity) {

        boolean flag = true;
        int count = activityDao.save(activity);
        if(count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public PaginationVo<Activity> pageList(Map<String, Object> map) {

        int total = activityDao.getTotalByCondition(map);

        List<Activity> dataList = activityDao.getActivityListByCondition(map);

        PaginationVo<Activity> vo = new PaginationVo<>();
        vo.setDataList(dataList);
        vo.setTotal(total);

        return vo;
    }

    @Override
    public Boolean delete(String[] ids) {

        boolean flag = true;

        // 查询出需要删除的备注的数量
        int need_count = remarkDao.getCountByAids(ids);

        // 删除备注,返回受到影响的条数
        int delete_count = remarkDao.deleteByAids(ids);

        if(delete_count != need_count)
        {
            flag = false;
        }

        // 删除市场活动
        int activity_updateNum = activityDao.delete(ids);

        if(activity_updateNum != ids.length)
        {
            flag = false;
        }

        return flag;
    }
}



package com.xiaolanhe.crm.workbench.dao;

/**
 * @author xiaolanhe
 * @create 2021-08-11 19:29
 */
public interface ActivityRemarkDao {

    int deleteByAids(String[] ids);

    int getCountByAids(String[] ids);
}

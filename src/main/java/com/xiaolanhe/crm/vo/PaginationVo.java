package com.xiaolanhe.crm.vo;

import java.util.List;

/**
 * @author xiaolanhe
 * @create 2021-08-14 10:44
 */
public class PaginationVo<T> {
    private int total; // 总记录数
    private List<T> dataList;

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}



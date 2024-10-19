package com.sky.mapper;

import com.sky.entity.OrderDetail;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface OrderDetailMapper {
    /**
     * 批量插入订单明细
     * @param list
     */
    void insertBatch(List<OrderDetail> list);

    @Select("SELECT * FROM order_detail WHERE id = #{id}")
    List<OrderDetail> getByOrderId(Long id);
}

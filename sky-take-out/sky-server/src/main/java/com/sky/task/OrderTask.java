package com.sky.task;

import com.sky.entity.Orders;
import com.sky.mapper.OrderMapper;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.weaver.ast.Or;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 定时处理订单状态:
 * 1.1min 查看一次已超时支付订单并修改 这里没删除，只有状态变cancel
 * 2. 每天凌晨一点清除 ”配送中“ 的订单
 */


@Component
@Slf4j
public class OrderTask {

    @Autowired
    private OrderMapper orderMapper;

    /**
     * 处理超时订单  1min查看一次，清除15min前的订单
     */
    @Scheduled(cron = "0 * * * * ?")
    public void processTimeoutOrder(){
        log.info("定时处理超市订单：{}", LocalDateTime.now());

        //查找15分钟前的订单
        LocalDateTime time = LocalDateTime.now().plusMinutes(-15);
        //查 判 改
        List<Orders> ordersList = orderMapper.getStatusAndOrderTimeLT(Orders.PENDING_PAYMENT, time);

        //update
        if(ordersList != null && ordersList.size() > 0){
            for(Orders orders : ordersList){
                orders.setStatus(Orders.CANCELLED);
                orders.setCancelReason("timeover");
                orders.setCancelTime(LocalDateTime.now());
                orderMapper.update(orders); //修改
            }
        }






    }

    /**
     * 处理配送中订单  凌晨一点触发，删除上一天的订单
     */
    @Scheduled(cron = "0 0 1 * * ?")
    public void processDeliveryOrder(){
        log.info("处理派送中订单：{}",LocalDateTime.now());

        //查找15分钟前的订单
        LocalDateTime time = LocalDateTime.now().plusMinutes(-60);
        //查 判 改
        List<Orders> ordersList = orderMapper.getStatusAndOrderTimeLT(Orders.DELIVERY_IN_PROGRESS, time);

        //update
        if(ordersList != null && ordersList.size() > 0){
            for(Orders orders : ordersList){
                orders.setStatus(Orders.COMPLETED);
                orders.setCancelReason("timeover");
                orders.setCancelTime(LocalDateTime.now());
                orderMapper.update(orders); //修改
            }
        }

    }



}

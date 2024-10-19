package com.sky.controller.user;


import com.sky.dto.OrdersCancelDTO;
import com.sky.dto.OrdersPaymentDTO;
import com.sky.dto.OrdersSubmitDTO;
import com.sky.entity.Orders;
import com.sky.result.PageResult;
import com.sky.result.Result;
import com.sky.service.OrderService;
import com.sky.vo.OrderPaymentVO;
import com.sky.vo.OrderStatisticsVO;
import com.sky.vo.OrderSubmitVO;
import com.sky.vo.OrderVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.constraints.Size;

@RestController
@RequestMapping("/user/order")
@Api(tags = "C端订单接口")
@Slf4j
public class OrderController {

    @Autowired
    private OrderService orderService;

    /**
     * vx支付调用流程： 1.submit 2.payment 3.回调notify中paysuccess 4.paysuccess会调用orderservice包下paysuccess(用来修改订单状态)
     * @param ordersSubmitDTO
     * @return
     */
    @PostMapping("/submit")
    @ApiOperation("用户下单")
    public Result<OrderSubmitVO> submit(@RequestBody OrdersSubmitDTO ordersSubmitDTO){
        log.info("用户下单:{}",ordersSubmitDTO);
        OrderSubmitVO orderSubmitVO = orderService.submitOrder(ordersSubmitDTO);

        return Result.success(orderSubmitVO);
    }

    /**
     * 用户取消，居然不给原因传参，真傻逼
     * @param id
     * @return
     */
    @PutMapping("/cancel/{id}")
    @ApiOperation("取消下单")
    public Result cancel(@PathVariable Long id){

        log.info("用户取消订单：{}",id);

        OrdersCancelDTO o = new OrdersCancelDTO();
        o.setId(id);
        o.setCancelReason("用户取消订单");
        orderService.cancel(o);
        return Result.success();

    }



    //差一个订单支付，没有id写不了
    /**
     * 订单支付
     *
     * @param ordersPaymentDTO
     * @return
     */
    @PutMapping("/payment")
    @ApiOperation("订单支付")
    public Result<OrderPaymentVO> payment(@RequestBody OrdersPaymentDTO ordersPaymentDTO) throws Exception {
        log.info("订单支付：{}", ordersPaymentDTO);
        OrderPaymentVO orderPaymentVO = orderService.payment(ordersPaymentDTO);
        //此时流程图完成至第八步，把拿回的信息还给小程序
        log.info("生成预支付交易单：{}", orderPaymentVO);
        return Result.success(orderPaymentVO);
    }

    /**
     * 客户催单
     * @param id
     * @return
     */
    @GetMapping("/reminder/{id}")
    @ApiOperation("客户催单")
    public Result reminder(@PathVariable Long id){

        orderService.reminder(id);
        return Result.success();
    }

    @PostMapping("/repetition/{id}")
    @ApiOperation("再来一单")
    public Result repeteOrder(@PathVariable Long id){

        log.info("再来一单！：{}",id);

        orderService.repeteOrder(id);

        return Result.success();

    }

    @GetMapping("/historyOrders")
    @ApiOperation("历史订单查询")
    public Result<PageResult> historyOrders(int page,int pageSize,Integer status){

        log.info("历史订单查询！");

        PageResult pageResult = orderService.historyOrders(page,pageSize,status);

        return Result.success(pageResult);

    }

    /**
     * 查询订单详情
     */
    @GetMapping("/orderDetail/{id}")
    @ApiOperation("查询订单详情")
    public Result<OrderVO> orderDetailById(@PathVariable Long id){

        log.info("订单VO查询：{}",id);

        OrderVO o = orderService.SearchOrderDetailById(id);

        return Result.success(o);
    }


}

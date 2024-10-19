package com.sky.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.databind.ser.Serializers;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.sky.config.WebSocketConfiguration;
import com.sky.constant.MessageConstant;
import com.sky.context.BaseContext;
import com.sky.dto.*;
import com.sky.entity.*;
import com.sky.exception.AddressBookBusinessException;
import com.sky.exception.OrderBusinessException;
import com.sky.exception.ShoppingCartBusinessException;
import com.sky.mapper.*;
import com.sky.properties.WeChatProperties;
import com.sky.result.PageResult;
import com.sky.service.OrderService;
import com.sky.utils.WeChatPayUtil;
import com.sky.vo.OrderPaymentVO;
import com.sky.vo.OrderStatisticsVO;
import com.sky.vo.OrderSubmitVO;
import com.sky.vo.OrderVO;
import com.sky.websocket.WebSocketServer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


@Service
@Slf4j
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private OrderDetailMapper orderDetailMapper;

    @Autowired
    private AddressBookMapper addressBookMapper;

    @Autowired
    private ShoppingCartMapper shoppingCartMapper;

    @Autowired
    private WeChatPayUtil weChatPayUtil;

    @Autowired
    private UserMapper userMapper;


    @Autowired
    private WebSocketServer webSocketServer;



    /**
     * 用户下单
     * @param ordersSubmitDTO
     * @return
     */
    @Transactional
    @Override
    public OrderSubmitVO submitOrder(OrdersSubmitDTO ordersSubmitDTO) {
    //校验！！！


        //1. 先拿地址
        AddressBook addressBook = addressBookMapper.getById(ordersSubmitDTO.getAddressBookId());
        if(addressBook == null){
            //地址根本就没有(昂与字段与实体表不对应)
            throw new AddressBookBusinessException(MessageConstant.ADDRESS_BOOK_IS_NULL);
        }

        //查找该用户购物车。其实ShoppingCart存的是用户的一个物品，一个购物车应该是多条数据构成
        ShoppingCart shoppingCart = new ShoppingCart();

        shoppingCart.setUserId(BaseContext.getCurrentId());//设置用户id

        List<ShoppingCart> shoppingCarts = shoppingCartMapper.list(shoppingCart);
        //购物车校验
        if(shoppingCarts == null || shoppingCarts.size() == 0){
            //购物车没有or空
            throw new ShoppingCartBusinessException(MessageConstant.SHOPPING_CART_IS_NULL);

        }

    //逻辑
        //订单表插入一条数据
        Orders orders = new Orders();
        BeanUtils.copyProperties(ordersSubmitDTO,orders);

            //设置空缺属性 ()挨个属性对一下
        orders.setOrderTime(LocalDateTime.now());
        orders.setPayStatus(Orders.UN_PAID);//pay status
//        orders.setStatus(Orders.PENDING_PAYMENT);//order status

        orders.setStatus(Orders.TO_BE_CONFIRMED);//看controller调用流程，没vx所以这里默认支付成功

        orders.setNumber(String.valueOf(System.currentTimeMillis()));//使用时间戳作为订单号
        orders.setPhone(addressBook.getPhone());
        orders.setConsignee(addressBook.getConsignee());//收货人
        orders.setUserId(BaseContext.getCurrentId());


        orderMapper.insert(orders); //这里插入时已经自动给id赋值

        //订单明细表加入n条数据
        List<OrderDetail> list = new ArrayList<>();

        for(ShoppingCart cart : shoppingCarts){
            //每个都要分化装成一个detail对象
            OrderDetail orderDetail = new OrderDetail();
            BeanUtils.copyProperties(cart,orderDetail);
            //补充
            orderDetail.setOrderId(orders.getId());

            list.add(orderDetail);
        }
            //批量插入 所以订单细节有多个？每个细节包含的其实是一个物品的详细信息？amount在丢给前端算？
        orderDetailMapper.insertBatch(list);
        //清空购物车
        shoppingCartMapper.deleteByUserId(BaseContext.getCurrentId());

        //封装VO
        OrderSubmitVO orderSubmitVO =  OrderSubmitVO.builder()
                .id(orders.getId())
                .orderAmount(orders.getAmount())
                .orderNumber(orders.getNumber())
                .build();

        return orderSubmitVO;

    }

    /**
     * 订单支付
     *
     * @param ordersPaymentDTO
     * @return
     */
    public OrderPaymentVO payment(OrdersPaymentDTO ordersPaymentDTO) throws Exception {
        //skip payment
//        // 当前登录用户id
//        Long userId = BaseContext.getCurrentId();
//        User user = userMapper.getById(userId);
//
//        //调用微信支付接口，生成预支付交易单   pay函数对应流程图第五步 这个函数 包含了 发送给微信并且数据的拿回处理
//        JSONObject jsonObject = weChatPayUtil.pay(
//                ordersPaymentDTO.getOrderNumber(), //商户订单号
//                new BigDecimal(0.01), //支付金额，单位 元
//                "苍穹外卖订单", //商品描述
//                user.getOpenid() //微信用户的openid
//        );
//
//        //处理成vo返回
//        if (jsonObject.getString("code") != null && jsonObject.getString("code").equals("ORDERPAID")) {
//            throw new OrderBusinessException("该订单已支付");
//        }
//
//        OrderPaymentVO vo = jsonObject.toJavaObject(OrderPaymentVO.class);
//        vo.setPackageStr(jsonObject.getString("package"));
//
//        return vo;

        //随便传
        OrderPaymentVO vo = new OrderPaymentVO();
        vo.setNonceStr("666");
        vo.setPaySign("hhh");
        vo.setPackageStr("prepay_id=wx");
        vo.setSignType("RSA");
        vo.setTimeStamp("1670380960");


        return vo;

    }

    /**
     *
     * 这里是几把的 支付功能第八步往后
     * 支付成功，修改订单状态
     *
     * 调不到，没vx，所以直接在pay那一栏修改 看上面sb
     *
     * @param outTradeNo
     */
    public void paySuccess(String outTradeNo) {

        // 根据订单号查询订单
        Orders ordersDB = orderMapper.getByNumber(outTradeNo);

        // 根据订单id更新订单的状态、支付方式、支付状态、结账时间
        Orders orders = Orders.builder()
                .id(ordersDB.getId())
                .status(Orders.TO_BE_CONFIRMED)
                .payStatus(Orders.PAID)
                .checkoutTime(LocalDateTime.now())
                .build();

        orderMapper.update(orders);




        //websocket推送您有新的订单给admin
        Map m = new HashMap();
        m.put("type",1);
        m.put("orderId",ordersDB.getId());
        m.put("content","订单号：" + outTradeNo);

        String json = JSON.toJSONString(m);
        webSocketServer.sendToAllClient(json);



    }

    /**
     * 客户催单
     * @param id
     */
    @Override
    public void reminder(Long id) {
        Orders orders = orderMapper.getById(id);

        //是否存在？
        if(orders == null){
            throw new OrderBusinessException(MessageConstant.ORDER_NOT_FOUND);
        }

        Map m = new HashMap();

        m.put("type",2);//1 来单体型 2 用户催单 这是和前端约定好了的
        m.put("orderId",id);
        m.put("content","订单号" + orders.getNumber());

        String json = JSON.toJSONString(m);


        //websocket
        webSocketServer.sendToAllClient(json);
    }

    /**
     * 再来一单 就是把数据再添加到购物车就好
     * @param id
     */
    @Override
    public void repeteOrder(Long id) {
        //拿到对应细节表
        List<OrderDetail> orderDetailList = orderDetailMapper.getByOrderId(id);

        Long userId = BaseContext.getCurrentId();

        //为每一个cart赋值  这个设计我觉得好sb，为什么要加个细节，就为了再来一单？这个细节和cart表基本一样啊
        List<ShoppingCart> shoppingCarts = orderDetailList.stream().map(x ->{
            ShoppingCart shoppingCart = new ShoppingCart();

            //copy
            BeanUtils.copyProperties(x,shoppingCart,"id");
            shoppingCart.setUserId(userId);
            shoppingCart.setCreateTime(LocalDateTime.now());

            return shoppingCart;
        }).collect(Collectors.toList());

        //再批量添加
        shoppingCarts.forEach(x -> {
            shoppingCartMapper.insert(x);
        });




    }

    @Override
    public PageResult historyOrders(int page, int pageSize, Integer status) {

        PageHelper.startPage(page,pageSize);

        OrdersPageQueryDTO ordersPageQueryDTO = new OrdersPageQueryDTO();
        ordersPageQueryDTO.setUserId(BaseContext.getCurrentId());
        ordersPageQueryDTO.setStatus(status);

        Page<Orders> p = orderMapper.pageQuery(ordersPageQueryDTO);

        //总共订单的LIst
        List<OrderVO> list = new ArrayList<>();

        if(p != null && p.getTotal() > 0){
            for(Orders o : p){
                //每一个order，拿出它对应的orderDetails，然后一起封装金orderVO
                Long orderId = o.getId();

                List<OrderDetail> orderDetails = orderDetailMapper.getByOrderId(orderId);

                OrderVO orderVO = new OrderVO();
                BeanUtils.copyProperties(o,orderVO);
                orderVO.setOrderDetailList(orderDetails);

                list.add(orderVO);

            }
        }
        return new PageResult(p.getTotal(), list);





    }

    @Override
        public void cancel(OrdersCancelDTO ordersCancelDTO) {
        Long id = ordersCancelDTO.getId();
        Orders orders = orderMapper.getById(id);

        if(orders == null){
            throw new OrderBusinessException(MessageConstant.ORDER_NOT_FOUND);
        }

        //订单状态 1待付款 2待接单 3已接单 4派送中 5已完成 6已取消
        if(orders.getStatus() > 2){
            throw new OrderBusinessException(MessageConstant.ORDER_STATUS_ERROR);
        }

        //处于接单下，需要退金额
//        if(orders.getStatus().equals(Orders.TO_BE_CONFIRMED)){
//            //没id，直接输出就行
//
//        }
        orders.setStatus(Orders.CANCELLED);
//        orders.setCancelReason("用户取消");
        orders.setCancelTime(LocalDateTime.now());
        orders.setRejectionReason(ordersCancelDTO.getCancelReason());
        //update
        orderMapper.update(orders);

    }

    @Override
    public OrderVO SearchOrderDetailById(Long id) {

        List<OrderDetail> list = orderDetailMapper.getByOrderId(id);
        Orders o = orderMapper.getById(id);

        OrderVO orderVO = new OrderVO();
        BeanUtils.copyProperties(o,orderVO);
        orderVO.setOrderDetailList(list);

        return orderVO;


    }

    @Override
    public PageResult conditionSearch(OrdersPageQueryDTO ordersPageQueryDTO) {
        PageHelper.startPage(ordersPageQueryDTO.getPage(),ordersPageQueryDTO.getPageSize());

        Page<Orders> list = orderMapper.pageQuery(ordersPageQueryDTO);

        PageResult pageResult = new PageResult(list.getTotal(),list);

        return pageResult;

    }

    @Override
    public OrderStatisticsVO statistics() {

        Map m = new HashMap<>();
        m.put("status",Orders.TO_BE_CONFIRMED);
        Integer tobeConfirmed = orderMapper.countByMap(m);

        m.replace("status",Orders.TO_BE_CONFIRMED,Orders.CONFIRMED);
        Integer confirmed = orderMapper.countByMap(m);

        m.replace("status",Orders.CONFIRMED,Orders.DELIVERY_IN_PROGRESS);
        Integer delivery = orderMapper.countByMap(m);

        OrderStatisticsVO o = new OrderStatisticsVO();
        o.setToBeConfirmed(tobeConfirmed);
        o.setConfirmed(confirmed);
        o.setDeliveryInProgress(delivery);

        return o;
    }

    @Override
    public void confirm(OrdersConfirmDTO ordersConfirmDTO) {
        Long orderId = ordersConfirmDTO.getId();

        Orders o = orderMapper.getById(orderId);

        o.setStatus(Orders.CONFIRMED);
        orderMapper.update(o);

    }

    @Override
    public void rejection(OrdersRejectionDTO ordersRejectionDTO) {
        Long orderId = ordersRejectionDTO.getId();

        Orders o = orderMapper.getById(orderId);

        o.setStatus(Orders.CANCELLED);
        o.setRejectionReason(ordersRejectionDTO.getRejectionReason());

        orderMapper.update(o);

    }

    /**
     * 个complete一样好像就该状态就行了把。。。
     * @param id
     */
    @Override
    public void delivery(Long id) {

        Orders o = orderMapper.getById(id);
        o.setStatus(Orders.DELIVERY_IN_PROGRESS);
        orderMapper.update(o);
    }

    @Override
    public void complete(Long id) {
        Orders o = orderMapper.getById(id);
        o.setStatus(Orders.COMPLETED);
        orderMapper.update(o);
    }

}

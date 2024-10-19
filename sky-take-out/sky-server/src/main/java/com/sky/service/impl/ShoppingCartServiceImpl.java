package com.sky.service.impl;

import com.sky.context.BaseContext;
import com.sky.dto.ShoppingCartDTO;
import com.sky.entity.Dish;
import com.sky.entity.Setmeal;
import com.sky.entity.ShoppingCart;
import com.sky.mapper.DishMapper;
import com.sky.mapper.SetmealMapper;
import com.sky.mapper.ShoppingCartMapper;
import com.sky.result.PageResult;
import com.sky.service.ShoppingCartService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;


@Slf4j
@Service
public class ShoppingCartServiceImpl implements ShoppingCartService {

    @Autowired
    private ShoppingCartMapper shoppingCartMapper;
    @Autowired
    private DishMapper dishMapper;
    @Autowired
    private SetmealMapper setmealMapper;

    /**
     * 添加购物车
     * 注意，进来的可能是菜品的id也可能是套餐的id，要具体分析if一下
     * @param shoppingCartDTO
     */
    @Override
    public void addShoppingCart(ShoppingCartDTO shoppingCartDTO) {
        ShoppingCart shoppingCart = new ShoppingCart();
        BeanUtils.copyProperties(shoppingCartDTO,shoppingCart);
        //差个登录的id
        shoppingCart.setUserId(BaseContext.getCurrentId());
        //这里条件动态的，所以套餐还是菜品一律都走这个函数
        List<ShoppingCart> list = shoppingCartMapper.list(shoppingCart);//0 or 1
        //判断是否已经存在

        //存在则更新其number，加一
        if(list != null && list.size() > 0){
            ShoppingCart shoppingCart1 = list.get(0);
            shoppingCart1.setNumber(shoppingCart1.getNumber()+1);
            //update
            shoppingCartMapper.updateNumberById(shoppingCart1);//大量使用下则没必要通用

        }else{        //不存在再插入该条数据
            //先要分清是菜品还是套餐。知晓了才能拿信息

            Long dishId = shoppingCartDTO.getDishId();
            if(dishId != null){//菜品
                //查菜品表具体信息
                Dish dish = dishMapper.getById(dishId);
                //赋值
                shoppingCart.setName(dish.getName());
                shoppingCart.setImage(dish.getImage());
                shoppingCart.setAmount(dish.getPrice());

                shoppingCart.setNumber(1);
                shoppingCart.setCreateTime(LocalDateTime.now());

            }else{//套餐
                Long SetmealId = shoppingCartDTO.getSetmealId();

                Setmeal setmeal = setmealMapper.getById(SetmealId);

                shoppingCart.setName(setmeal.getName());
                shoppingCart.setImage(setmeal.getImage());
                shoppingCart.setAmount(setmeal.getPrice());

                shoppingCart.setNumber(1);
                shoppingCart.setCreateTime(LocalDateTime.now());

            }
            //ShoppingCart 同一插入 shoppingCart
            shoppingCart.setUserId(BaseContext.getCurrentId());
            shoppingCartMapper.insert(shoppingCart);
        }




    }

    /**
     * 查购物车
     * @return
     */
    @Override
    public List<ShoppingCart> showShoppingCart() {
        //构造条件，只需要给userid差自己的购物车记录即可

        Long userId = BaseContext.getCurrentId();

        ShoppingCart shoppingCart = new ShoppingCart();
        shoppingCart.setUserId(userId);

        List<ShoppingCart> shoppingCarts = shoppingCartMapper.list(shoppingCart);
        return shoppingCarts;
    }

    /**
     * 清空购物车
     */
    @Override
    public void cleanShoppingCart() {
        Long userId = BaseContext.getCurrentId();

        shoppingCartMapper.deleteByUserId(userId);
    }
}

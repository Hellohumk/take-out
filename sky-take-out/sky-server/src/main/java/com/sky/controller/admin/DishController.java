package com.sky.controller.admin;


import com.sky.annotaion.AutoFill;
import com.sky.constant.StatusConstant;
import com.sky.dto.DishDTO;
import com.sky.dto.DishPageQueryDTO;
import com.sky.entity.Dish;
import com.sky.result.PageResult;
import com.sky.result.Result;
import com.sky.service.DishService;
import com.sky.vo.DishVO;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/admin/dish")
@Slf4j
public class DishController {

    @Autowired
    private DishService dishService;

    @Autowired
    private RedisTemplate redisTemplate;


    @GetMapping("/page")
    @ApiOperation("菜品分页查询")
    public Result<PageResult> page(DishPageQueryDTO dishPageQueryDTO){
        log.info("菜品分页查询：{}",dishPageQueryDTO);
        PageResult pageResult = dishService.pageQuery(dishPageQueryDTO);
        return Result.success(pageResult);
    }

    @DeleteMapping
    @ApiOperation("菜品批量删除")
    public Result delete(@RequestParam List<Long> ids){
        log.info("菜品批量删除：{}",ids);
        dishService.deleteBatch(ids);

        //redis 删除（这里会影响多个表,干脆全删）
        cleanCache("category_*"); //正则表达式，传入模式（String）


        return Result.success();
    }

    @GetMapping("/{id}")
    @ApiOperation("根据id查询菜品")
    public Result<DishVO> getById(@PathVariable Long id){
        log.info("根据id查询菜品 {}",id);
        DishVO dishVO = dishService.getByIdWithFlavor(id);
        return Result.success(dishVO);
    }

    @PutMapping
    @ApiOperation("修改菜品")
    public Result update(@RequestBody DishDTO dishDTO){
        log.info("修改菜品 {}",dishDTO);
        dishService.updateWithFlavor(dishDTO);

        //如果你修改的是一个分类，那对应的扽类表也得动，故全删
        cleanCache("category_*"); //正则表达式，传入模式（String）


        return Result.success();
    }

    @PostMapping("/status/{status}")
    @ApiOperation("菜品起售停售")
    public Result startOrStop(@PathVariable Integer status,Long id){
        log.info("菜品起售停售：{}，{}",status,id);
        dishService.startOrStop(status,id);

//复杂，全删
        cleanCache("category_*"); //正则表达式，传入模式（String）

        return Result.success();
    }

    @PostMapping()
    @ApiOperation("新增菜品")
    public Result save(@RequestBody DishDTO dishDTO){
        log.info("新增菜品： {}" ,dishDTO);
        dishService.saveWithFlavor(dishDTO);

        //redis 删除缓存 ：这里是精确清理，简单业务
        String key = "category_" + dishDTO.getCategoryId();
        redisTemplate.delete(key);
        return Result.success();
    }

    /**
     * 清理缓存数据
     * @param pattern
     */
    private void cleanCache(String pattern){
        Set keys = redisTemplate.keys(pattern);
        redisTemplate.delete(keys);//delete支持传入set批量删除
    }

    /**
     * test  list
     */
    /**
     * 根据分类id查询菜品
     *
     * @param categoryId
     * @return
     */
    @GetMapping("/list")
    @ApiOperation("根据分类id查询菜品")
    public Result<List<DishVO>> list(Long categoryId) {

        //redis处理高并发
        //构造redis的key，规则：category_id  :  List <DishVO>
        String key = "category_" + categoryId;

        //查询redis是否存在菜品  (放进去什么类型的对象，取出来就应该是什么类型)
        List<DishVO> list = (List<DishVO>) redisTemplate.opsForValue().get(key);
        if(list != null && list.size() > 0){
            //如果存在，直接返回，无需查询数据库
            return Result.success(list);
        }




        Dish dish = new Dish();
        dish.setCategoryId(categoryId);
        dish.setStatus(StatusConstant.ENABLE);//查询起售中的菜品

        //公用一个变量list
        list = dishService.listWithFlavor(dish);

        //不存在，查询数据库，将查询的数据放入redis中（写回）
        redisTemplate.opsForValue().set(key,list);

        return Result.success(list);
    }










}

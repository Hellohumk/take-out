package com.sky.aspect;

import com.sky.annotaion.AutoFill;
import com.sky.constant.AutoFillConstant;
import com.sky.context.BaseContext;
import com.sky.enumeration.OperationType;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.time.LocalDateTime;

/**
 * aop自动填充公共字段
 */

@Aspect
@Component
@Slf4j
public class AutoFillAspect {
    /**
     * pointcut
     */
    @Pointcut("execution(* com.sky.mapper.*.*(..)) && @annotation(com.sky.annotaion.AutoFill)")
    public void autoFillPointcut(){}


    @Before("autoFillPointcut()")
    public void autoFill(JoinPoint joinPoint){
        log.info("begin to aop");

        //1. 获取被拦截方法类型 (反射机制)
        //aop实现了反射机制，直接可以拿到signature对象，反射中通过signature拿到对应。class信息
        MethodSignature signature = ( MethodSignature ) joinPoint.getSignature();
        AutoFill autoFill = signature.getMethod().getAnnotation(AutoFill.class);//获得方法上的注解对象
        OperationType  operationType = autoFill.value();//这里相当于拿到了操作类型

        //2. 获取被拦截方法参数
        Object[] args = joinPoint.getArgs();
        if(args==null || args.length == 0){
            return ;
        }

        //拿到实体对象(参数的)
        Object entity = args[0];
        //3.数据准备
        LocalDateTime now = LocalDateTime.now();
        Long currentid = BaseContext.getCurrentId();

        //4.数据输入   这里为了通用性，写了反射，所以看起来很复杂
        //insert 要改更新和创建时间，update只用改更新时间
        if(operationType == OperationType.INSERT){

            try{//拿到现在操作对应实体的方法执行（通用），而不是直接settime巴拉巴拉  这里使用的方法名也通过常量名注入了
                Method setCreateTime = entity.getClass().getDeclaredMethod(AutoFillConstant.SET_CREATE_TIME,LocalDateTime.class);
                Method setCreateUser = entity.getClass().getDeclaredMethod(AutoFillConstant.SET_CREATE_USER,Long.class);
                Method setUpdateTime = entity.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_TIME,LocalDateTime.class);
                Method setUpdateUser = entity.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_USER,Long.class);

                setCreateTime.invoke(entity,now);
                setCreateUser.invoke(entity,currentid);
                setUpdateTime.invoke(entity,now);
                setUpdateUser.invoke(entity,currentid);


            }catch(Exception e){//没有这种方法
                e.printStackTrace();
            }
        }else if(operationType == OperationType.UPDATE){
            try{//拿到现在操作对应实体的方法执行（通用），而不是直接settime巴拉巴拉
                Method setUpdateTime = entity.getClass().getDeclaredMethod("setUpdateTime",LocalDateTime.class);
                Method setUpdateUser = entity.getClass().getDeclaredMethod("setUpdateUser",Long.class);

                setUpdateTime.invoke(entity,now);
                setUpdateUser.invoke(entity,currentid);


            }catch(Exception e){//没有这种方法
                e.printStackTrace();
            }
        }

    }

}

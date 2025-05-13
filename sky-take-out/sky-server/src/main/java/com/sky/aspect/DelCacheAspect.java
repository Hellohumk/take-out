package com.sky.aspect;

import com.sky.annotaion.DelCache;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.util.concurrent.TimeUnit;

@Aspect
@Component
public class DelCacheAspect {
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Pointcut("@annotation(com.sky.annotaion.DelCache)")
    public void DelCachePointcut(){}

    @Around("DelCachePointcut()")
    public Object aroundAdvice(ProceedingJoinPoint joinPoint) throws Throwable {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        DelCache keyAnnotation = method.getAnnotation(DelCache.class);

        // 方法执行前删除缓存
        String cacheKey = keyAnnotation.CacheName();
        deleteCache(cacheKey);

        Object result = joinPoint.proceed();

        // 异步执行延时删除缓存
        asyncDeleteCache(cacheKey);

        return result;
    }

    @Async
    public void asyncDeleteCache(String cacheKey) {
        try {
            TimeUnit.MILLISECONDS.sleep(100); // 延时100毫秒
            deleteCache(cacheKey);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    private void deleteCache(String cacheKey) {
        redisTemplate.delete(cacheKey);
    }
}

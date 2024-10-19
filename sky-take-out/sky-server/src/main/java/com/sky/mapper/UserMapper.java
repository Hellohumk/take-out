package com.sky.mapper;

import com.sky.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.Map;

@Mapper
public interface UserMapper {

    @Select("Select * from user where openid = #{openid}")
    User getByOpenid(String openid);

    /**
     * 插入数据
     * @param user
     */
    void insert(User user);

    @Select("SELECT * from user WHERE id = #{userId}")
    User getById(Long userId);

    /**
     * 有多少新
     * @param map
     * @return
     */
    Integer countByMap(Map map);

    @Select("SELECT COUNT(*) FROM user ")
    Integer countId();
}

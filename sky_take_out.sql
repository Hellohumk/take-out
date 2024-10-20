/*
 Navicat Premium Dump SQL

 Source Server         : localroot
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : sky_take_out

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 20/10/2024 22:01:14
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address_book
-- ----------------------------
DROP TABLE IF EXISTS `address_book`;
CREATE TABLE `address_book`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `consignee` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '收货人',
  `sex` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '性别',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '手机号',
  `province_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '省级区划编号',
  `province_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '省级名称',
  `city_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '市级区划编号',
  `city_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '市级名称',
  `district_code` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区级区划编号',
  `district_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区级名称',
  `detail` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '详细地址',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '默认 0 否 1是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '地址簿' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of address_book
-- ----------------------------
INSERT INTO `address_book` VALUES (2, 4, '666', '0', '13419698938', '11', '北京市', '1101', '市辖区', '110102', '西城区', '123', '1', 1);
INSERT INTO `address_book` VALUES (3, 4, '123', '0', '13911488209', '11', '北京市', '1101', '市辖区', '110102', '西城区', '132', '1', 0);

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `type` int NULL DEFAULT NULL COMMENT '类型   1 菜品分类 2 套餐分类',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '分类名称',
  `sort` int NOT NULL DEFAULT 0 COMMENT '顺序',
  `status` int NULL DEFAULT NULL COMMENT '分类状态 0:禁用，1:启用',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint NULL DEFAULT NULL COMMENT '创建人',
  `update_user` bigint NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_category_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '菜品及套餐分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (23, 1, '新品上市', 1, 1, '2024-10-20 17:38:07', '2024-10-20 17:39:59', 1, 1);
INSERT INTO `category` VALUES (24, 1, '好味道大师造', 2, 1, '2024-10-20 17:38:25', '2024-10-20 17:40:00', 1, 1);
INSERT INTO `category` VALUES (25, 1, '招牌推荐', 3, 1, '2024-10-20 17:38:32', '2024-10-20 17:40:01', 1, 1);
INSERT INTO `category` VALUES (26, 1, '经典双拼', 4, 1, '2024-10-20 17:38:38', '2024-10-20 17:40:03', 1, 1);
INSERT INTO `category` VALUES (27, 1, '精选套餐', 5, 1, '2024-10-20 17:38:49', '2024-10-20 17:40:05', 1, 1);
INSERT INTO `category` VALUES (28, 1, '加料专区', 6, 1, '2024-10-20 17:39:00', '2024-10-20 17:40:06', 1, 1);

-- ----------------------------
-- Table structure for dish
-- ----------------------------
DROP TABLE IF EXISTS `dish`;
CREATE TABLE `dish`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '菜品名称',
  `category_id` bigint NOT NULL COMMENT '菜品分类id',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '菜品价格',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '图片',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '描述信息',
  `status` int NULL DEFAULT 1 COMMENT '0 停售 1 起售',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint NULL DEFAULT NULL COMMENT '创建人',
  `update_user` bigint NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_dish_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 111 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '菜品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dish
-- ----------------------------
INSERT INTO `dish` VALUES (76, '孜然鸡柳饭', 23, 13.90, 'http://127.0.0.1:8080/files/4bf1c4b6-b3bd-4ea8-adaf-1c5523a6f29e6.png', '', 1, '2024-10-20 20:55:25', '2024-10-20 20:55:25', 1, 1);
INSERT INTO `dish` VALUES (85, '泰式酱香鸡', 23, 13.90, 'http://127.0.0.1:8080/files/1.png', '', 1, '2024-10-20 21:20:54', '2024-10-20 21:20:54', 1, 1);
INSERT INTO `dish` VALUES (87, '新式卤肉饭', 23, 13.90, 'http://127.0.0.1:8080/files/2.png', '', 1, '2024-10-20 21:33:08', '2024-10-20 21:33:08', 1, 1);
INSERT INTO `dish` VALUES (88, '麻辣鱿鱼饭', 23, 13.90, 'http://127.0.0.1:8080/files/3.png', '', 1, '2024-10-20 21:35:51', '2024-10-20 21:35:51', 1, 1);
INSERT INTO `dish` VALUES (89, '红烧肉拼鸡排', 26, 14.90, 'http://127.0.0.1:8080/files/5.png', '', 1, '2024-10-20 21:37:09', '2024-10-20 21:37:09', 1, 1);
INSERT INTO `dish` VALUES (90, '土豆拼牛腩', 26, 14.90, 'http://127.0.0.1:8080/files/6.png', '', 1, '2024-10-20 21:37:41', '2024-10-20 21:37:41', 1, 1);
INSERT INTO `dish` VALUES (91, '泰皇烤肉饭', 23, 13.90, 'http://127.0.0.1:8080/files/44bd5f68-f281-4138-9e83-8f0f936ba0916.jpg', '', 1, '2024-10-20 21:38:01', '2024-10-20 21:38:01', 1, 1);
INSERT INTO `dish` VALUES (92, '黑椒鸡扒饭', 25, 11.90, 'http://127.0.0.1:8080/files/8.png', '', 1, '2024-10-20 21:38:30', '2024-10-20 21:38:30', 1, 1);
INSERT INTO `dish` VALUES (93, '香肠一根', 28, 1.50, 'http://127.0.0.1:8080/files/11.png', '', 1, '2024-10-20 21:38:49', '2024-10-20 21:38:49', 1, 1);
INSERT INTO `dish` VALUES (94, '牛腩拼茄子', 26, 14.90, 'http://127.0.0.1:8080/files/12.png', '', 1, '2024-10-20 21:39:14', '2024-10-20 21:39:14', 1, 1);
INSERT INTO `dish` VALUES (95, '可乐鸡饭', 24, 13.90, 'http://127.0.0.1:8080/files/18.png', '', 1, '2024-10-20 21:39:29', '2024-10-20 21:39:29', 1, 1);
INSERT INTO `dish` VALUES (96, '茄子拼鸡扒饭', 26, 14.90, 'http://127.0.0.1:8080/files/14.png', '', 1, '2024-10-20 21:39:46', '2024-10-20 21:39:46', 1, 1);
INSERT INTO `dish` VALUES (97, '梅菜烧肉饭', 23, 13.90, 'http://127.0.0.1:8080/files/15.png', '', 1, '2024-10-20 21:40:10', '2024-10-20 21:40:10', 1, 1);
INSERT INTO `dish` VALUES (98, '麻辣虾仁饭', 24, 14.90, 'http://127.0.0.1:8080/files/16.png', '', 1, '2024-10-20 21:40:47', '2024-10-20 21:40:47', 1, 1);
INSERT INTO `dish` VALUES (100, '咖喱鸡饭', 24, 14.90, 'http://127.0.0.1:8080/files/19.png', '', 1, '2024-10-20 21:42:26', '2024-10-20 21:42:26', 1, 1);
INSERT INTO `dish` VALUES (101, '酱肉土豆', 24, 11.90, 'http://127.0.0.1:8080/files/20.png', '', 1, '2024-10-20 21:42:48', '2024-10-20 21:42:48', 1, 1);
INSERT INTO `dish` VALUES (102, '鸡扒拼牛腩饭', 26, 14.90, 'http://127.0.0.1:8080/files/21.png', '', 1, '2024-10-20 21:43:10', '2024-10-20 21:43:10', 1, 1);
INSERT INTO `dish` VALUES (103, '单块鸡扒', 28, 5.00, 'http://127.0.0.1:8080/files/23.png', '', 1, '2024-10-20 21:43:30', '2024-10-20 21:43:30', 1, 1);
INSERT INTO `dish` VALUES (104, '海苔照烧鸡饭', 24, 13.90, 'http://127.0.0.1:8080/files/26.png', '', 1, '2024-10-20 21:44:07', '2024-10-20 21:44:07', 1, 1);
INSERT INTO `dish` VALUES (105, '咕噜肉饭', 23, 14.90, 'http://127.0.0.1:8080/files/27.png', '', 1, '2024-10-20 21:44:21', '2024-10-20 21:44:21', 1, 1);
INSERT INTO `dish` VALUES (106, '奥尔良烤肉饭', 24, 12.90, 'http://127.0.0.1:8080/files/830.png', '', 1, '2024-10-20 21:44:53', '2024-10-20 21:44:53', 1, 1);
INSERT INTO `dish` VALUES (107, '把子肉饭', 25, 13.90, 'http://127.0.0.1:8080/files/31.png', '', 1, '2024-10-20 21:45:12', '2024-10-20 21:45:12', 1, 1);
INSERT INTO `dish` VALUES (108, '叫花鸡饭', 23, 16.90, 'http://127.0.0.1:8080/files/32.png', '', 1, '2024-10-20 21:45:33', '2024-10-20 21:45:33', 1, 1);
INSERT INTO `dish` VALUES (109, '鲍汁捞饭', 24, 9.90, 'http://127.0.0.1:8080/files/33.png', '', 1, '2024-10-20 21:45:55', '2024-10-20 21:45:55', 1, 1);
INSERT INTO `dish` VALUES (110, '鲍汁茄子饭', 24, 9.90, 'http://127.0.0.1:8080/files/34.png', '', 1, '2024-10-20 21:46:13', '2024-10-20 21:46:13', 1, 1);

-- ----------------------------
-- Table structure for dish_flavor
-- ----------------------------
DROP TABLE IF EXISTS `dish_flavor`;
CREATE TABLE `dish_flavor`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dish_id` bigint NOT NULL COMMENT '菜品',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '口味名称',
  `value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '口味数据list',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 116 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '菜品口味关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dish_flavor
-- ----------------------------
INSERT INTO `dish_flavor` VALUES (104, 88, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (105, 90, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (106, 94, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (107, 97, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (108, 98, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (109, 100, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (110, 101, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (111, 102, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (112, 106, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');
INSERT INTO `dish_flavor` VALUES (113, 107, '忌口', '[\"不要葱\",\"不要蒜\",\"不要香菜\",\"不要辣\"]');
INSERT INTO `dish_flavor` VALUES (114, 109, '甜味', '[\"无糖\",\"少糖\",\"半糖\",\"多糖\",\"全糖\"]');
INSERT INTO `dish_flavor` VALUES (115, 110, '辣度', '[\"不辣\",\"微辣\",\"中辣\",\"重辣\"]');

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '姓名',
  `username` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '密码',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '手机号',
  `sex` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '性别',
  `id_number` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '身份证号',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态 0:禁用，1:启用',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint NULL DEFAULT NULL COMMENT '创建人',
  `update_user` bigint NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '员工信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES (1, '管理员', 'admin', '123456', '13812312312', '1', '110101199001010047', 1, '2022-02-15 15:51:20', '2022-02-17 09:16:20', 10, 1);

-- ----------------------------
-- Table structure for order_detail
-- ----------------------------
DROP TABLE IF EXISTS `order_detail`;
CREATE TABLE `order_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '名字',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '图片',
  `order_id` bigint NOT NULL COMMENT '订单id',
  `dish_id` bigint NULL DEFAULT NULL COMMENT '菜品id',
  `setmeal_id` bigint NULL DEFAULT NULL COMMENT '套餐id',
  `dish_flavor` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '口味',
  `number` int NOT NULL DEFAULT 1 COMMENT '数量',
  `amount` decimal(10, 2) NOT NULL COMMENT '金额',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '订单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_detail
-- ----------------------------
INSERT INTO `order_detail` VALUES (5, '鮰鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/8cfcc576-4b66-4a09-ac68-ad5b273c2590.png', 5, 67, NULL, '不辣', 1, 72.00);
INSERT INTO `order_detail` VALUES (6, '鮰鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/8cfcc576-4b66-4a09-ac68-ad5b273c2590.png', 6, 67, NULL, '不辣', 1, 72.00);
INSERT INTO `order_detail` VALUES (7, '江团鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/a101a1e9-8f8b-47b2-afa4-1abd47ea0a87.png', 6, 66, NULL, '不辣', 1, 119.00);
INSERT INTO `order_detail` VALUES (8, '鮰鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/8cfcc576-4b66-4a09-ac68-ad5b273c2590.png', 7, 67, NULL, '不辣', 1, 72.00);
INSERT INTO `order_detail` VALUES (9, '江团鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/a101a1e9-8f8b-47b2-afa4-1abd47ea0a87.png', 7, 66, NULL, '不辣', 1, 119.00);
INSERT INTO `order_detail` VALUES (10, '鮰鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/8cfcc576-4b66-4a09-ac68-ad5b273c2590.png', 8, 67, NULL, '不辣', 1, 72.00);
INSERT INTO `order_detail` VALUES (11, '江团鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/a101a1e9-8f8b-47b2-afa4-1abd47ea0a87.png', 8, 66, NULL, '不辣', 1, 119.00);
INSERT INTO `order_detail` VALUES (12, '东坡肘子', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/a80a4b8c-c93e-4f43-ac8a-856b0d5cc451.png', 9, 59, NULL, NULL, 1, 138.00);
INSERT INTO `order_detail` VALUES (13, '清蒸鲈鱼', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/c18b5c67-3b71-466c-a75a-e63c6449f21c.png', 9, 58, NULL, NULL, 1, 98.00);
INSERT INTO `order_detail` VALUES (14, '清炒小油菜', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/3613d38e-5614-41c2-90ed-ff175bf50716.png', 10, 54, NULL, '不要葱', 1, 18.00);
INSERT INTO `order_detail` VALUES (15, '清炒西兰花', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/e9ec4ba4-4b22-4fc8-9be0-4946e6aeb937.png', 10, 56, NULL, '不要葱', 1, 18.00);
INSERT INTO `order_detail` VALUES (16, '鮰鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/8cfcc576-4b66-4a09-ac68-ad5b273c2590.png', 11, 67, NULL, '不辣', 1, 72.00);
INSERT INTO `order_detail` VALUES (17, '江团鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/a101a1e9-8f8b-47b2-afa4-1abd47ea0a87.png', 12, 66, NULL, '不辣', 1, 119.00);
INSERT INTO `order_detail` VALUES (18, '鮰鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/8cfcc576-4b66-4a09-ac68-ad5b273c2590.png', 12, 67, NULL, '不辣', 1, 72.00);
INSERT INTO `order_detail` VALUES (19, '鮰鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/8cfcc576-4b66-4a09-ac68-ad5b273c2590.png', 13, 67, NULL, '不辣', 1, 72.00);
INSERT INTO `order_detail` VALUES (20, '江团鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/a101a1e9-8f8b-47b2-afa4-1abd47ea0a87.png', 13, 66, NULL, '不辣', 1, 119.00);
INSERT INTO `order_detail` VALUES (21, '草鱼2斤', 'https://sky-itcast.oss-cn-beijing.aliyuncs.com/b544d3ba-a1ae-4d20-a860-81cb5dec9e03.png', 14, 65, NULL, '不辣', 1, 68.00);
INSERT INTO `order_detail` VALUES (22, '美女', 'http://127.0.0.1:8080/img/7811d5fc-6dac-434f-a999-28c62e58a416.jpg', 15, 75, NULL, NULL, 14, 19.00);
INSERT INTO `order_detail` VALUES (23, '泰式酱香鸡', 'http://127.0.0.1:8080/files/1.png', 16, 85, NULL, NULL, 1, 13.90);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `number` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '订单号',
  `status` int NOT NULL DEFAULT 1 COMMENT '订单状态 1待付款 2待接单 3已接单 4派送中 5已完成 6已取消 7退款',
  `user_id` bigint NOT NULL COMMENT '下单用户',
  `address_book_id` bigint NOT NULL COMMENT '地址id',
  `order_time` datetime NOT NULL COMMENT '下单时间',
  `checkout_time` datetime NULL DEFAULT NULL COMMENT '结账时间',
  `pay_method` int NOT NULL DEFAULT 1 COMMENT '支付方式 1微信,2支付宝',
  `pay_status` tinyint NOT NULL DEFAULT 0 COMMENT '支付状态 0未支付 1已支付 2退款',
  `amount` decimal(10, 2) NOT NULL COMMENT '实收金额',
  `remark` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '备注',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '手机号',
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '地址',
  `user_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '用户名称',
  `consignee` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '收货人',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '订单取消原因',
  `rejection_reason` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '订单拒绝原因',
  `cancel_time` datetime NULL DEFAULT NULL COMMENT '订单取消时间',
  `estimated_delivery_time` datetime NULL DEFAULT NULL COMMENT '预计送达时间',
  `delivery_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '配送状态  1立即送出  0选择具体时间',
  `delivery_time` datetime NULL DEFAULT NULL COMMENT '送达时间',
  `pack_amount` int NULL DEFAULT NULL COMMENT '打包费',
  `tableware_number` int NULL DEFAULT NULL COMMENT '餐具数量',
  `tableware_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '餐具数量状态  1按餐量提供  0选择具体数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (5, '1727012364916', 1, 4, 2, '2024-09-22 21:39:25', NULL, 1, 0, 79.00, '', '13419698938', NULL, NULL, '666', NULL, NULL, NULL, '2024-09-22 22:39:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (6, '1727015999069', 1, 4, 2, '2024-09-22 22:39:59', NULL, 1, 0, 199.00, '', '13419698938', NULL, NULL, '666', NULL, NULL, NULL, '2024-09-22 23:39:00', 0, NULL, 2, 0, 0);
INSERT INTO `orders` VALUES (7, '1727016243893', 6, 4, 2, '2024-09-22 22:44:04', NULL, 1, 0, 199.00, '', '13419698938', NULL, NULL, '666', NULL, '菜品已销售完，暂时无法接单', '2024-09-22 23:54:39', '2024-09-22 23:44:00', 0, NULL, 2, 0, 0);
INSERT INTO `orders` VALUES (8, '1727016408492', 1, 4, 2, '2024-09-22 22:46:48', NULL, 1, 0, 199.00, '', '13419698938', NULL, NULL, '666', NULL, NULL, NULL, '2024-09-22 23:46:00', 0, NULL, 2, 0, 0);
INSERT INTO `orders` VALUES (9, '1727016447679', 1, 4, 2, '2024-09-22 22:47:28', NULL, 1, 0, 244.00, '', '13419698938', NULL, NULL, '666', NULL, NULL, NULL, '2024-09-22 23:47:00', 0, NULL, 2, 0, 0);
INSERT INTO `orders` VALUES (10, '1727016563436', 1, 4, 2, '2024-09-22 22:49:23', NULL, 1, 0, 44.00, '', '13419698938', NULL, NULL, '666', NULL, NULL, NULL, '2024-09-22 23:49:00', 0, NULL, 2, 0, 0);
INSERT INTO `orders` VALUES (11, '1727016877431', 1, 4, 3, '2024-09-22 22:54:37', NULL, 1, 0, 79.00, '', '13911488209', NULL, NULL, '123', NULL, NULL, NULL, '2024-09-22 23:54:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (12, '1727017261077', 5, 4, 3, '2024-09-22 23:01:01', NULL, 1, 0, 199.00, '', '13911488209', NULL, NULL, '123', NULL, NULL, NULL, '2024-09-22 00:01:00', 0, NULL, 2, 0, 0);
INSERT INTO `orders` VALUES (13, '1727018848862', 5, 4, 3, '2024-09-22 23:27:29', NULL, 1, 0, 199.00, '', '13911488209', NULL, NULL, '123', NULL, NULL, NULL, '2024-09-22 00:27:00', 0, NULL, 2, 0, 0);
INSERT INTO `orders` VALUES (14, '1727018869200', 6, 4, 2, '2024-09-22 23:27:49', NULL, 1, 0, 75.00, '', '13419698938', NULL, NULL, '666', NULL, 'SB', NULL, '2024-09-22 00:27:00', 0, NULL, 1, 0, 0);
INSERT INTO `orders` VALUES (15, '1727020726105', 5, 4, 2, '2024-09-22 23:58:46', NULL, 1, 0, 286.00, '', '13419698938', NULL, NULL, '666', NULL, NULL, NULL, '2024-09-22 00:58:00', 0, NULL, 14, 0, 0);
INSERT INTO `orders` VALUES (16, '1729432675430', 2, 4, 2, '2024-10-20 21:57:55', NULL, 1, 0, 20.90, '', '13419698938', NULL, NULL, '666', NULL, NULL, NULL, '2024-10-20 22:57:00', 0, NULL, 1, 0, 0);

-- ----------------------------
-- Table structure for setmeal
-- ----------------------------
DROP TABLE IF EXISTS `setmeal`;
CREATE TABLE `setmeal`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `category_id` bigint NOT NULL COMMENT '菜品分类id',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT '套餐名称',
  `price` decimal(10, 2) NOT NULL COMMENT '套餐价格',
  `status` int NULL DEFAULT 1 COMMENT '售卖状态 0:停售 1:起售',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '描述信息',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '图片',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `create_user` bigint NULL DEFAULT NULL COMMENT '创建人',
  `update_user` bigint NULL DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_setmeal_name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '套餐' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of setmeal
-- ----------------------------

-- ----------------------------
-- Table structure for setmeal_dish
-- ----------------------------
DROP TABLE IF EXISTS `setmeal_dish`;
CREATE TABLE `setmeal_dish`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `setmeal_id` bigint NULL DEFAULT NULL COMMENT '套餐id',
  `dish_id` bigint NULL DEFAULT NULL COMMENT '菜品id',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '菜品名称 （冗余字段）',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '菜品单价（冗余字段）',
  `copies` int NULL DEFAULT NULL COMMENT '菜品份数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '套餐菜品关系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of setmeal_dish
-- ----------------------------

-- ----------------------------
-- Table structure for shopping_cart
-- ----------------------------
DROP TABLE IF EXISTS `shopping_cart`;
CREATE TABLE `shopping_cart`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '商品名称',
  `image` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '图片',
  `user_id` bigint NOT NULL COMMENT '主键',
  `dish_id` bigint NULL DEFAULT NULL COMMENT '菜品id',
  `setmeal_id` bigint NULL DEFAULT NULL COMMENT '套餐id',
  `dish_flavor` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '口味',
  `number` int NOT NULL DEFAULT 1 COMMENT '数量',
  `amount` decimal(10, 2) NOT NULL COMMENT '金额',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '购物车' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shopping_cart
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `openid` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '微信用户唯一标识',
  `name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '姓名',
  `phone` varchar(11) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '手机号',
  `sex` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '性别',
  `id_number` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '身份证号',
  `avatar` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NULL DEFAULT NULL COMMENT '头像',
  `create_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_bin COMMENT = '用户信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (4, 'ozRly7d4I97GNqI75J9Enex5VEJ8', NULL, NULL, NULL, NULL, NULL, '2024-09-18 22:15:53');

SET FOREIGN_KEY_CHECKS = 1;

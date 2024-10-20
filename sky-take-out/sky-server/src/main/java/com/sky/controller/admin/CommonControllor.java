package com.sky.controller.admin;

import com.sky.constant.MessageConstant;
import com.sky.result.Result;
import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;



@RestController
@RequestMapping("/admin/common")
@Slf4j
@Api("文件上传admin")
public class CommonControllor {


    @PostMapping("/upload")
    public Result<String> upload(MultipartFile file) {
        log.info("文件上传:{}", file);
        String originalFilename = file.getOriginalFilename();
        try {
            if (originalFilename != null) {
                // 利用UUID构造新的文件名称
                String objectName = UUID.randomUUID().toString() + originalFilename;
                // 文件的请求路径
                String filePath = "D:\\JAVA-library\\SkyTakeOut\\sky-take-out\\files\\" + objectName;
                String returnImagePate = "http://127.0.0.1:8080/files/" + objectName;
                file.transferTo(new File(filePath));
                return Result.success(returnImagePate);
            } else {
                throw new IOException(MessageConstant.UPLOAD_FAILED);
            }
        } catch (IOException e) {
            e.printStackTrace();
            log.error("文件上传失败:{}", e);
        }
        return Result.error(MessageConstant.UPLOAD_FAILED);
    }

}

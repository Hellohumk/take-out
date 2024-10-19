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
    public Result<String> upload(MultipartFile file){

        log.info("upload files:{}",file);

        try{
            String originalName = file.getOriginalFilename();
            //拓展名
            String extName = originalName.substring(originalName.lastIndexOf("."));

            String filename = UUID.randomUUID() + extName;

            String fileurl = "D:\\JAVA-library\\sky-take-out\\sky-server\\src\\main\\resources\\static\\img\\" + filename;

            file.transferTo(new File(fileurl));

            String returnurl = "http://127.0.0.1:8080/img/" + filename;

            return Result.success(returnurl);
        }catch(IOException e){
            log.error("upload failed:{}",e);
        }
        return Result.error(MessageConstant.UPLOAD_FAILED);

    }


}

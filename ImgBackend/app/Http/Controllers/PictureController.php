<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/15 0015
 * Time: 19:33
 */

namespace App\Http\Controllers;


use Qiniu\Auth as Qauth;
use Qiniu\Storage\BucketManager;
use Qiniu\Storage\UploadManager;


define("Access_Key", "J1iZ-R07FP8alatNNy0YBCfYz423FXOOwzCwVZrB");    //七牛的AccKey
define("Secret_Key", "xrPRxScwNZIaRfOYRl1X_6Ugz-aQp_29afke7Pzc");    //七牛的SecKey

class PictureController extends Controller
{
    /**
     * 上传文件
     * @param $temp string 文件临时路径
     * @param $filename string 文件名
     * @param $bucket string 七牛空间名
     * @return mixed 返回信息
     */
    public function Create($temp, $filename, $bucket)
    {
        if (!$temp) {
            $result["status"] = 0;
            $result["errmsg"]["code"] = 100;
            $result["errmsg"]["content"] = "File is empty!";
        } else {
            $auth = new Qauth(Access_Key, Secret_Key);
            $uptoken = $auth->uploadToken($bucket, null, 3600);                //获取上传凭证
            $uploadMgr = new UploadManager();                                //创建上传管理类
            list($res, $error) = $uploadMgr->putFile($uptoken, $filename, $temp);
            if ($error !== null) {
                $result["status"] = 0;
                $result["errmsg"]["code"] = 101;
                $result["errmsg"]["content"] = "Upload Fail!";
            } else {
                $url = $this->GetUrl($bucket) . "/" . $res['key'];
                $result["status"] = 1;
                $result["errmsg"] = "OK!";
                $result["url"] = $url;
            }
        }
        return $result;
    }

    /**
     * 更新文件
     * @param $old_url string 要删除旧的文件的url
     * @param $temp string 要上传新的文件的临时路径
     * @param $bucket string 七牛空间名
     * @param $filename string 新文件名
     * @return mixed 返回信息
     */
    public function Update($old_url, $temp, $bucket, $filename)
    {
        if (!$temp) {
            $result["status"] = 0;
            $result["errmsg"]["code"] = 100;
            $result["errmsg"]["content"] = "File is empty!";
        } else {
            $auth = new Qauth(Access_Key, Secret_Key);
            $bucketMgr = new BucketManager($auth);                      //获取空间管理权力
            $del_key = substr(strrchr($old_url, '/'), 1);            //获取url中的key值
            $del_res = $bucketMgr->delete($bucket, $del_key);   //根据key值删除资源
            if ($del_res !== null) {
                $result["status"] = 0;
                $result["errmsg"]["code"] = 103;
                $result["errmsg"]["delete"] = "Delete Fail!";
            }

            $uptoken = $auth->uploadToken($bucket, null, 3600);  //获取上传凭证
            $uploadMgr = new UploadManager();                         //创建上传管理类
            list($res, $error) = $uploadMgr->putFile($uptoken, $filename, $temp);

            if ($error !== null) {
                $result["status"] = 0;
                $result["errmsg"]["code"] = 103;
                $result["errmsg"]["upload"] = "Upload Fail!";
            } else {
                $url = $this->GetUrl($bucket) . "/" . $res['key'];
                $result["status"] = 1;
                $result["errmsg"] = "OK!";
                $result["url"] = $url;
            }
        }
        return $result;
    }

    /**
     * 删除文件
     * @param $url string 要删除的文件url地址
     * @param $bucket string 要删除的文件所在的bucket
     * @return mixed  返回信息
     */
    public function Delete($url, $bucket)
    {
        $auth = new Qauth(Access_Key, Secret_Key);
        $bucketMgr = new BucketManager($auth);                     //获取空间管理权力
        $del_key = substr(strrchr($url, '/'), 1);                    //获取url中的key值
        $del_res = $bucketMgr->delete($bucket, $del_key);           //根据key值删除资源
        if ($del_res !== null) {
            $result["status"] = 0;
            $result["errmsg"]["code"] = 102;
            $result["errmsg"]["content"] = "Delete Fail!";
        } else {
            $result["status"] = 1;
            $result["errmsg"] = "OK!";
        }
        return $result;
    }

    /**
     * 返回七牛域名
     * @return string   Tip:更换账号时，此项需要修改
     */
    public function GetUrl($bucket)
    {
        switch ($bucket) {
            case "cifa"   :
                return "opzr2ftyc.bkt.clouddn.com";
            case "avatar" :
                return "opzyum71r.bkt.clouddn.com";
        }
    }
}
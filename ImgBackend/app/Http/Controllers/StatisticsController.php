<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/27 0027
 * Time: 15:38
 */

namespace App\Http\Controllers;


use App\Models\Image;
use App\Models\Tag;
use App\Models\UserTag;
use App\User;

class StatisticsController extends Controller
{
    /**
     *
     * @SWG\GET(path="/statistics",
     *   tags={"获取APP总统计数据"},
     *   summary="获取APP总统计数据",
     *   description="不需登陆直接获取",
     *   operationId="Statistics",
     *   produces={"application/json"},
     *   @SWG\Response(
     *     response="200",
     *     examples={
    "ret_msg": "success",
    "data": {
    "RegisterNum": {
    "total": 1,
    "month": 1,
    "today": 1
    },
    "AddImageNum": {
    "total": 3,
    "month": 0,
    "today": 0
    },
    "AddTagNum": {
    "total": 8,
    "month": 1,
    "today": 0
    },
    "ImageAndTag": {
    "tag": 3,
    "image": 3
    },
    "UserAndTag": {
    "user": 1,
    "tag": 3
    }
    }
    },
     *     description="返回管理员信息",
     *     @SWG\Schema(ref="#/definitions/")
     * )
     * )
     */
    public function getData()
    {
        $data = [
            'RegisterNum' => $this->registerNum(),
            'AddImageNum' => $this->addImageNum(),
            'AddTagNum' => $this->addTagNum(),
            'ImageAndTag' => $this->imageAndTagNum(),
            'UserAndTag' => $this->userAndTag()
        ];
        $success = success('success', $data);
        return $this->response->array($success)->setStatusCode(200);
    }

    private function registerNum()
    {
        $todayNum = User::getUser()->where('created_at', '>', getToday())->count();
        $monthNum = User::getUser()->where('created_at', '>', getMonth())->count();
        $totalNum = User::getUser()->count();
        return [
            'total' => $totalNum,
            'month' => $monthNum,
            'today' => $todayNum
        ];
    }

    private function addImageNum()
    {
        $todayNum = Image::where('created_at', '>', getToday())->count();
        $monthNum = Image::where('created_at', '>', getMonth())->count();
        $totalNum = Image::count();
        return [
            'total' => $totalNum,
            'month' => $monthNum,
            'today' => $todayNum
        ];
    }

    private function addTagNum()
    {
        $todayNum = UserTag::where('created_at', '>', getToday())->count();
        $monthNum = UserTag::where('created_at', '>', getMonth())->count();
        $totalNum = UserTag::count();
        return [
            'total' => $totalNum,
            'month' => $monthNum,
            'today' => $todayNum
        ];
    }

    private function imageAndTagNum()
    {
        $tagNum = Tag::count();
        $imageNum = Image::count();
        return [
            'tag' => $tagNum,
            'image' => $imageNum
        ];
    }

    private function userAndTag()
    {
        $userNum = User::getUser()->count();
        $tagNum = Tag::count();
        return [
            'user' => $userNum,
            'tag' => $tagNum
        ];
    }
}
<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/27 0027
 * Time: 0:22
 */

namespace App\Http\Controllers\System;


use App\Events\StatisticsTagEvent;
use App\Http\Controllers\Controller;
use App\Models\Image;
use App\Models\Result;
use App\Models\ScoreTag;
use App\Models\Tag;
use App\Models\UserInfo;
use App\Models\UserTag;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Validator;


class TagController extends Controller
{
    //标签映射标号文件路径
    const LABEL_FILE_PATH = '/home/wwwroot/cifar/public/cifar/caffe/examples/alexnet_my/label.txt';

    const CHANGE_LABEL_COMMAND = 'python /home/wwwroot/cifar/public/cifar/caffe/examples/alexnet_my/change_label_of_prototxt.py';


    /**
     *
     * @SWG\POST(path="/Tag/add",
     *   tags={"用户标签管理"},
     *   summary="给图片打上标签",
     *   description="需要已登录的普通用户，给图片打上标签",
     *   operationId="Tag_add",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="header",
     *     name="Authorization",
     *     type="string",
     *     description="value值为Bearer+空格+token值",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="body",
     *     name="Tags",
     *     type="string",
     *     description="标签与图片对应的数组，具体例子看postman",
     *     required=true,
     *     @SWG\Schema(ref="#/definitions/Image_tag")
     *   ),
     *   @SWG\Response(
     *     response="201",
     *     description="图片标记成功，并返回出错的i_id数组,如果无出错i_id则data为空数组",
     *     examples={
    "ret_msg": "success",
    "data": {
    0
    }
    },
     *     @SWG\Schema(ref="#/definitions/Image_tagArr")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     * )
     */
    public function add(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'Tags' => 'required'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);                     //字段不通过验证
        }

        $Req = $request->only('Tags');

        $tags = $Req['Tags'];

        $userId = Auth::user()->id;

        $error_Ids = [];

        $finish_sum = 0;

        foreach ($tags as $tag) {
            $tag_name = $tag['t_name'];
            $i_id = $tag['i_id'];
            if (Image::isExist($i_id) == false) {
                $error_Ids[] = $i_id;
                continue;
            }
            $t_id = $this->getTagId($tag_name);
            UserTag::create([
                't_id' => $t_id,
                'i_id' => $i_id,
                'userId' => $userId
            ]);
            Event::fire(new StatisticsTagEvent($i_id, $t_id));
            $finish_sum += 1;
        }

        UserInfo::addScore($userId, $finish_sum);

        return $this->response->created(null, success('success', $error_Ids));
    }

    public function getTagId($tag_name)
    {
        $data = Tag::where('t_name', $tag_name)->first();
        if ($data) {
            return $data->t_id;
        } else {
            $data = Tag::create(['t_name' => $tag_name]);
            $file = fopen(self::LABEL_FILE_PATH, 'a+');
            fwrite($file, $tag_name . "\n");
            fclose($file);
            exec(self::CHANGE_LABEL_COMMAND);
            return $data->t_id;
        }
    }

    /**
     *
     * @SWG\POST(path="/Tag/mark",
     *   tags={"用户标签管理"},
     *   summary="给图片评分",
     *   description="需要已登录的普通用户，给图片评分",
     *   operationId="Tag_mark",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="header",
     *     name="Authorization",
     *     type="string",
     *     description="value值为Bearer+空格+token值",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="body",
     *     name="Scores",
     *     type="string",
     *     description="评分与图片对应的数组，具体例子看postman",
     *     required=true,
     *     @SWG\Schema(ref="#/definitions/Image_mark")
     *   ),
     *   @SWG\Response(
     *     response="201",
     *     description="图片标记成功，并返回出错的i_id数组,如果无出错i_id则data为空数组",
     *     examples={
    "ret_msg": "success",
    "data": {
    0
    }
    },
     *     @SWG\Schema(ref="#/definitions/Image_tagArr")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     * )
     */
    public function mark(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'Scores' => 'required'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);                     //字段不通过验证
        }

        $scores = $request->Scores;

        $userId = Auth::user()->id;

        $error_Ids = [];

        foreach ($scores as $item) {
            $score = $item['score'];
            $i_id = $item['i_id'];
            $score = ($score >= 0 && $score <= 10) ? $score : 0;
            $result = Result::find($i_id);
            if (empty($result)) {                                   //结果集无数据
                $error_Ids[] = $i_id;
                continue;
            }
            $tag_name = $result->tag1;                             //默认只采用结果集第一个标签
            $t_id = Tag::where('t_name', $tag_name)->first();      //根据标签名寻找标签id
            if ($t_id) {
                $t_id = $t_id->t_id;
            } else {                                               //根据标签名寻找不了标签id
                $error_Ids[] = $i_id;
                continue;
            }
            $create = ['userId' => $userId, 'score' => $score, 't_id' => $t_id];
            //写入到用户评分标签表
            if (($score_tag = ScoreTag::where('userId', $userId)->where('t_id', $t_id)->first())) {
                $score_tag->update($create);
            } else {
                ScoreTag::create($create);
            }
        }

        return $this->response->created(null, success('success', $error_Ids));
    }


    /**
     *
     * @SWG\GET(path="/Tag/getHistory",
     *   tags={"用户标签管理"},
     *   summary="获取用户标记历史",
     *   description="需要已登录的普通用户，获取用户标记历史",
     *   operationId="Tag_getHistory",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="header",
     *     name="Authorization",
     *     type="string",
     *     description="value值为Bearer+空格+token值",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="201",
     *     description="返回用户标记历史",
     *     examples={
    "ret_msg": "success",
    "data": {
    {
    "ut_id": 17,
    "userId": 6,
    "t_id": 14,
    "i_id": 1,
    "created_at": "-0001-11-30 00:00:00",
    "updated_at": "-0001-11-30 00:00:00",
    "tag_data": {
    "t_id": 14,
    "t_name": "测试标签"
    },
    "image_data": {
    "i_id": 1,
    "url": "abc",
    "filename": "",
    "created_at": null,
    "updated_at": null
    }
    }
    }
    },
     *     @SWG\Schema(ref="#/definitions/")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     * )
     */
    public function getHistory()
    {
        $userId = Auth::user()->id;

        $data = UserTag::where('userId', $userId)->get();

        if (!$data->isEmpty()) {
            $data = $data->transform(function ($item, $key) {
                $tag = Tag::find($item->t_id);
                $image = Image::find($item->i_id);
                $item->tag_data = $tag->toArray();
                $item->image_data = $image->toArray();
                return $item;
            });
        }

        $success = success('success', $data->toArray());

        return $this->response->array($success)->setStatusCode(200);
    }

    /**
     *
     * @SWG\GET(path="/Tag/getCommend",
     *   tags={"用户标签管理"},
     *   summary="随机获取推荐标签",
     *   description="需要已登录的普通用户，随机获取推荐标签（默认5个）",
     *   operationId="Tag_getCommend",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="header",
     *     name="Authorization",
     *     type="string",
     *     description="value值为Bearer+空格+token值",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="200",
     *     description="返回5个推荐标签历史",
     *     examples={
    "ret_msg": "success",
    "data": {
    "0": {
    "t_id": 14,
    "t_name": "测试标签"
    },
    "1": {
    "t_id": 15,
    "t_name": "测试标签2"
    },
    "3": {
    "t_id": 17,
    "t_name": "abc"
    },
    "5": {
    "t_id": 19,
    "t_name": "测试标签232423"
    },
    "6": {
    "t_id": 20,
    "t_name": "测试标签3565"
    }
    }
    },
     *     @SWG\Schema(ref="#/definitions/")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="489",
     *     description="数据库标签数量不足",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     * )
     */
    public function getCommend()
    {
        $tag=Tag::all();
        try{
            $tag=$tag->random(5);
        } catch (\Exception $e){
            return $this->response->error('没有多余标签',489);
        }
        $success=success('success',$tag->toArray());

        return $this->response->array($success)->setStatusCode(200);
    }
}
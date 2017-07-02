<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/26 0026
 * Time: 16:01
 */

namespace App\Http\Controllers\System;


use App\Http\Controllers\Controller;
use App\Models\Hobby;
use App\Models\HobbyHistory;
use App\Models\Image;
use App\Models\Result;
use App\Models\ScoreHistory;
use App\Models\ScoreTag;
use App\Models\SequenceRecord;
use App\Models\Tag;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class PushController extends Controller
{
    /**
     *  顺序匹配的开始id
     */
    const START_ID = 503;

    /**
     * 最大匹配结果标签 等于2即只拿结果集的TAG1，TAG2
     * 值不大于5
     */
    const MAX_MATCH_TAG = 1;

    /**
     *  评分推送时匹配标签用
     * 最大匹配结果标签 等于2即只拿结果集的TAG1，TAG2
     * 值不大于5
     */
    const MAX_MATCH_TAG_SCORE = 1;

    /**
     *
     * @SWG\GET(path="/Push/getSequence",
     *   tags={"推送图片"},
     *   summary="顺序推送图片",
     *   description="需要已登录的普通用户，按照图片id的顺序推送图片",
     *   operationId="push_getSequence",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="header",
     *     name="Authorization",
     *     type="string",
     *     description="value值为Bearer+空格+token值",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="query",
     *     name="number",
     *     type="integer",
     *     description="推送的数量(最小为1)",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="200",
     *     description="返回图片以及其标签集",
     *     examples={
    "ret_msg": "success",
    "data": {
    {
    "i_id": 1,
    "url": "abc",
    "filename": "",
    "created_at": null,
    "update_at": null,
    "finalTag": {
    {
    "i_id": 1,
    "tag1": "abc",
    "tag2": "cde",
    "tag3": "fgh",
    "tag4": "ijk",
    "tag5": "lmn",
    "Alternation": 0
    }
    }
    }
    }
    },
     *     @SWG\Schema(ref="#/definitions/Push_getSequence")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     * )
     */
    public function getSequence(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'number' => 'required|int|min:1'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);
        }

        $Req = $request->only('number');

        $userId = Auth::user()->id;

        $record = SequenceRecord::where('userId', $userId)->first();


        if (empty($record)) {
            $record = SequenceRecord::create([
                'userId' => $userId,
                'last_id' => self::START_ID
            ]);
            $last = self::START_ID;
        } else {
            $last = $record->last_id;
        }

        $Ids = range($last, $last + $Req['number'] - 1);

        $images = Image::getImage($Ids)->get();

        $effectNum = $images->count();

        $images = $images->transform(function ($item, $key) {
            $temp = $item->getResult()->first()->toArray();
            $item->finalTag = $temp;
            return $item;
        });

        $record->last_id = $effectNum + $last;

        $record->save();

//        /**
//         *  为了方便测试 重置
//         */
//        $record->delete();
        $last_data=Image::orderBy('i_id','desc')->limit(1)->first();

        if(($last_data->i_id)<($record->last_id)){
            $record->delete();
        }

        $success = success('success', $images->toArray());

        return $this->response->array($success)->setStatusCode(200);
    }


    /**
     *
     * @SWG\GET(path="/Push/byHobby",
     *   tags={"推送图片"},
     *   summary="按用户兴趣推送图片",
     *   description="需要已登录的普通用户，按照用户设定的兴趣模糊推送图片",
     *   operationId="push_byHobby",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="header",
     *     name="Authorization",
     *     type="string",
     *     description="value值为Bearer+空格+token值",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="query",
     *     name="number",
     *     type="integer",
     *     description="推送的数量(最小为1)",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="200",
     *     description="返回图片以及其标签集",
     *     examples={
    "ret_msg": "success",
    "data": {
    {
    "i_id": 1,
    "url": "abc",
    "filename": "",
    "created_at": null,
    "update_at": null,
    "finalTag": {
    {
    "i_id": 1,
    "tag1": "abc",
    "tag2": "cde",
    "tag3": "fgh",
    "tag4": "ijk",
    "tag5": "lmn",
    "Alternation": 0
    }
    }
    }
    }
    },
     *     @SWG\Schema(ref="#/definitions/Push_getSequence")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="480",
     *     description="用户还没设置兴趣",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * )
     * )
     */
    public function byHobby(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'number' => 'required|int|min:1'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);
        }

        $number = $request->number;

        $userId = Auth::user()->id;

        $hobby = Hobby::getHobbies($userId)->get();

        if ($hobby->isEmpty()) {
            return $this->response->error('have no hobby data!', 480);    // 没有兴趣数据
        }

        $collection = collect([]);

        //获取匹配的结果
        $hobby->each(function ($item, $key) use (&$collection) {
            for ($i = 1; $i <= self::MAX_MATCH_TAG; $i++) {
                $keyword = $item->hobby_name;
                $field = 'tag' . $i;
                $part = Result::where($field, 'like', '%' . $keyword . '%')->get();
                $collection = $collection->merge($part);
            }
        });

        $hobby_history = HobbyHistory::where('userId', $userId)->select('i_id')->get();

        //过滤已推送图片
        $collection = $collection->filter(function ($item) use ($hobby_history) {
            $i_id = $item->i_id;
            if ($hobby_history->contains('i_id', $i_id)) return false;
            else return true;
        });
        $collection=$collection->flatten();     //降维 过滤函数会使集合升维

        $collection = $collection->forPage(1, $number);

        if (!$collection->isEmpty()) {
            //添加到推送记录
            $collection->each(function ($item, $key) use ($userId) {
                $i_id = $item->i_id;
                /**
                 *  为了方便测试 重置
                 */
                HobbyHistory::create(['userId' => $userId, 'i_id' => $i_id]);
            });

            //修改结果格式
            $collection = $collection->transform(function ($item, $key) {
                $i_id = $item->i_id;
                $data = Image::find($i_id);
                $final_tag = $item->toArray();
                $item = $data;
                $item->finalTag = $final_tag;
                return $item;
            });
        }

        $success = success('success', $collection->toArray());

        return $this->response->array($success)->setStatusCode(200);
    }


    /**
     *
     * @SWG\GET(path="/Push/byScore",
     *   tags={"推送图片"},
     *   summary="按用户评分推送图片",
     *   description="需要已登录的普通用户，按照用户之前的评分推送图片",
     *   operationId="push_byScore",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="header",
     *     name="Authorization",
     *     type="string",
     *     description="value值为Bearer+空格+token值",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="query",
     *     name="number",
     *     type="integer",
     *     description="推送的数量(最小为1)",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="query",
     *     name="min",
     *     type="integer",
     *     description="推送的最低评分(范围0-10)",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="200",
     *     description="返回图片以及其标签集",
     *     examples={
    "ret_msg": "success",
    "data": {
    {
    "i_id": 1,
    "url": "abc",
    "filename": "",
    "created_at": null,
    "update_at": null,
    "finalTag": {
    {
    "i_id": 1,
    "tag1": "abc",
    "tag2": "cde",
    "tag3": "fgh",
    "tag4": "ijk",
    "tag5": "lmn",
    "Alternation": 0
    }
    }
    }
    }
    },
     *     @SWG\Schema(ref="#/definitions/Push_getSequence")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="481",
     *     description="用户还没评分或者min值过高获取不了合适的数据",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * )
     * )
     */
    public function byScore(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'number' => 'required|int|min:1',
            'min' => 'required|int|min:0|max:10'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);
        }

        $number = $request->number;

        $min = $request->min;

        $userId = Auth::user()->id;

        $collection = collect([]);

        $tags = ScoreTag::where('userId', $userId)->where('score', '>=', $min)->orderBy('score', 'desc')->select('t_id')->get();

        if(empty($tags)){
            return $this->response->error('用户还没评分或者min值过高获取不了合适的数据',481);
        }

        //匹配符合结果
        $tags->each(function ($item, $key) use (&$collection) {
            $t_id = $item->t_id;
            $t_name=Tag::find($t_id)->t_name;
            for ($i = 1; $i <= self::MAX_MATCH_TAG_SCORE; $i++) {
                $field = 'tag' . $i;
                $part=Result::where($field,$t_name)->get();
                $collection=$collection->merge($part);
            }
        });

        $history=ScoreHistory::where('userId',$userId)->select('i_id')->get();

        //过滤历史推送
        $collection=$collection->filter(function($item) use ($history){
            $i_id=$item->i_id;
            if ($history->contains('i_id', $i_id)) return false;
            else return true;
        });
        $collection=$collection->flatten();     //降维 过滤函数会使集合升维

        $collection = $collection->forPage(1, $number);

        if (!$collection->isEmpty()) {
            //添加到推送记录
            $collection->each(function ($item, $key) use ($userId) {
                $i_id = $item->i_id;
                /**
                 *  为了方便测试 重置
                 */
                //ScoreHistory::create(['userId' => $userId, 'i_id' => $i_id]);
            });

            //修改结果格式
            $collection = $collection->transform(function ($item, $key) {
                $i_id = $item->i_id;
                $data = Image::find($i_id);
                $final_tag = $item->toArray();
                $item = $data;
                $item->finalTag = $final_tag;
                return $item;
            });
        }

        $success = success('success', $collection->toArray());

        return $this->response->array($success)->setStatusCode(200);
    }
}
<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/17 0017
 * Time: 11:21
 */

namespace App\Http\Controllers\Admin;


use App\Events\StatisticsTagEvent;
use App\Exceptions\ResultException;
use App\Http\Controllers\Controller;
use App\Jobs\UpdateModelJob;
use App\Models\Result;
use App\Models\StatisticsTag;
use App\Models\Tag;
use App\Models\UpdateRecord;
use App\Models\UserTag;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Validator;
use App\Events\ExportModelEvent;
use App\Http\Controllers\PictureController;
use App\Models\Image;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;


class ImageController extends Controller
{
    //图片下载地址 (暂定 Train文件夹)
    const FILE_PATH = '/home/wwwroot/cifar/public/cifar/caffe/examples/alexnet_my/data/train/';

    /**
     *
     * @SWG\POST(path="/Admin/Image/add",
     *   tags={"图片处理"},
     *   summary="上传图片",
     *   description="需要已登录的管理员，进行上传图片,上传成功会返回图片的url",
     *   operationId="Image_add",
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
     *     name="image",
     *     type="string",
     *     description="图片base64编码",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="201",
     *     description="图片上传成功",
     *     @SWG\Schema(ref="#/definitions/success_ret")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="470",
     *     description="上传失败",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     * )
     */
    public function add(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'image' => 'required'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);
        }

        $Req = $request->only('image');

        $adminId = Auth::user()->id;

        $PC = new PictureController();

        $filename = time() . '_' . str_random(3);

        $result = $PC->Create($Req['image'], $filename, image_bucket);

        if (!isset($result['url'])) {
            return $this->response->error('upload fails!', 470);    //上传失败
        } else {

            $image = Image::Create(['userId' => $adminId, 'url' => $result['url']]);

            $i_id = $image->i_id;

            $filename = $this->downloadToTrain($i_id, $result['url']);

            $image->filename = $filename;

            $image->save();

            Event::fire(new ExportModelEvent($filename, $i_id));         //触发输出模型事件 @todo 可以补充异常抛出

            $success = success('success', ['url' => $result['url']]);

            return $this->response->created(null, $success);
        }
    }

    /**
     *  私有方法 把url图片下载到本地
     * @param $i_id
     * @param $url
     * @return string
     */
    private function downloadToTrain($i_id, $url)
    {
        $file = self::FILE_PATH . $i_id . '.png';
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_POST, 0);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        $file_content = curl_exec($ch);
        curl_close($ch);
        $downloaded_file = fopen($file, 'w');
        fwrite($downloaded_file, $file_content);
        fclose($downloaded_file);
        return $i_id . '.png';
    }

    /**
     *
     * @SWG\GET(path="/Admin/Image/getList",
     *   tags={"图片处理"},
     *   summary="获取图片列表(分页)",
     *   description="需要已登录的管理员，获取图库的图片列表",
     *   operationId="Image_getList",
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
     *     name="page",
     *     type="integer",
     *     description="第几页(从1开始)",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="query",
     *     name="perPage",
     *     type="integer",
     *     description="每页显示多少个(值为0则显示全部)",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="200",
     *     description="获取图片列表成功,主体信息在data中,会附带部分分页信息,按需使用",
     *     examples={
    "ret_msg": "success",
    "data": {
    "total": 3,
    "per_page": "1",
    "current_page": 1,
    "last_page": 3,
    "next_page_url": "http://localhost:8080/api/v1/Admin/Image/getList?page=2",
    "prev_page_url": null,
    "from": 1,
    "to": 1,
    "data": {
    {
    "i_id": 1,
    "url": "abc",
    "filename": "",
    "created_at": null,
    "update_at": null
    }
    }
    }
    },
     *     @SWG\Schema(ref="#/definitions/Image_list")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     * )
     */
    public function getList(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'perPage' => 'required|int|min:0',
            'page' => 'required|int'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);
        }

        $Req = $request->only('perPage', 'page');

        $perPage = $Req['perPage'];

        $page = $Req['page'];

        $images = Image::paginate($perPage, ['*'], 'page', $page);

        $success = success('success', $images->toArray());

        return $this->response->array($success)->setStatusCode(200);
    }

    /**
     *
     * @SWG\GET(path="/Admin/Image/getResult",
     *   tags={"图片处理"},
     *   summary="获取某张图片的结果",
     *   description="需要已登录的管理员，获取图库的图片标签结果",
     *   operationId="Image_getResult",
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
     *     name="i_id",
     *     type="integer",
     *     description="图片id",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="200",
     *     description="结果集合",
     *     examples={
    "ret_msg": "success",
    "data": {
    "i_id": 1,
    "tag1": "abc",
    "tag2": "cde",
    "tag3": "fgh",
    "tag4": "ijk",
    "tag5": "lmn",
    "Alternation": 0
    }
    },
     *     @SWG\Schema(ref="#/definitions/Image_set")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="404",
     *     description="路由错误或者参数id错误",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="471",
     *     description="结果集生成失败!请检查数据库",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     * )
     */
    public function getResult(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'i_id' => 'required|int'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);
        }

        $Req = $request->only('i_id');

        $i_id = $Req['i_id'];

        try {
            $image = Image::findOrFail($i_id);
        } catch (\Exception $e) {
            throw new NotFoundHttpException;
        }

        Event::fire(new ExportModelEvent($image->filename, $i_id));

        try {
            $result = Result::findOrFail($i_id);
        } catch (\Exception $e) {
            throw new ResultException(471, '结果集生成失败!');
        }
        $success = success('success', $result->toArray());

        return $this->response->array($success)->setStatuscode(200);
    }

    /**
     *
     * @SWG\PUT(path="/Admin/Image/statistics",
     *   tags={"图片处理"},
     *   summary="统计某张图片所有用户标签",
     *   description="需要已登录的管理员，统计某张图片所有用户标签",
     *   operationId="Image_statistics",
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
     *     name="i_id",
     *     type="integer",
     *     description="图片id",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="201",
     *     description="统计成功",
     *     @SWG\Schema(ref="#/definitions/success_ret")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="404",
     *     description="路由错误或者参数id错误",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="450",
     *     description="该图片仍未收到用户所打的标签",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     * )
     */
    public function statistics(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'i_id' => 'required|int'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);
        }

        $Req = $request->only('i_id');

        $i_id = $Req['i_id'];

        try {
            $image = Image::findOrFail($i_id);
        } catch (\Exception $e) {
            throw new NotFoundHttpException;
        }

        $collection = UserTag::getAllTagByImage($i_id)->get(['t_id']);

        if (!empty($collection)) {
            $collection = $collection->each(function ($item, $key) use ($i_id) {
                $t_id = $item->t_id;
                Event::fire(new StatisticsTagEvent($i_id, $t_id));
            });
            return $this->response->created(null, success('success'));
        } else {
            return $this->response->error('该图片仍未收到用户标签', 450);
        }
    }

    /**
     *
     * @SWG\GET(path="/Admin/Image/getStatisticsResult",
     *   tags={"图片处理"},
     *   summary="获取图片标签统计结果",
     *   description="需要已登录的管理员，获取图片标签统计结果",
     *   operationId="Image_getResult",
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
     *     name="i_id",
     *     type="integer",
     *     description="图片id",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="200",
     *     description="返回某张图片用户所打标签的统计结果",
     *     examples={
    "ret_msg": "success",
    "data": {
    "sum": 7,
    "data": {
    {
    "st_id": 7,
    "i_id": 1,
    "t_id": 16,
    "num": 2,
    "t_name": "测试标签3"
    },
    {
    "st_id": 6,
    "i_id": 1,
    "t_id": 15,
    "num": 2,
    "t_name": "测试标签2"
    },
    {
    "st_id": 5,
    "i_id": 1,
    "t_id": 14,
    "num": 3,
    "t_name": "测试标签"
    }
    }
    }
    },
     *     @SWG\Schema(ref="#/definitions/Image_statisticsResult")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="404",
     *     description="路由错误或者参数id错误",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     * )
     */
    public function getStatisticsResult(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'i_id' => 'required|int'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);
        }

        $Req = $request->only('i_id');

        $i_id = $Req['i_id'];

        try {
            Image::findOrFail($i_id);
        } catch (\Exception $e) {
            throw new NotFoundHttpException;
        }

        $collection = StatisticsTag::where('i_id', $i_id)->get();

        $sum = 0;

        if (!empty($collection)) {
            $collection = $collection->transform(function ($item, $key) use (&$sum) {
                $tag = Tag::find($item->t_id);
                $item->t_name = $tag ? $tag->t_name : null;
                $sum += $item->num;
                return $item;
            });
        } else {
            $collection = [];
        }

        $success = success('success', ['sum' => $sum, 'data' => $collection]);

        return $this->response->array($success)->setStatusCode(200);
    }

    /**
     *
     * @SWG\PUT(path="/Admin/Image/updateModel",
     *   tags={"图片处理"},
     *   summary="更新模型",
     *   description="需要已登录的管理员，根据统计情况，将标签放入更新模型中",
     *   operationId="Image_updateModel",
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
     *     name="i_id",
     *     type="integer",
     *     description="图片id",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="query",
     *     name="t_id",
     *     type="integer",
     *     description="标签id",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="201",
     *     description="更新模型成功",
     *     @SWG\Schema(ref="#/definitions/success_ret")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="404",
     *     description="路由错误或者参数id错误",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     * )
     */
    public function updateModel(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'i_id' => 'required|int',
            't_id' => 'required|int'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);
        }

        $Req = $request->only('i_id', 't_id');

        $i_id = $Req['i_id'];

        $t_id = $Req['t_id'];

        try {
            $image = Image::findOrFail($i_id);
            Tag::findOrFail($t_id);
        } catch (\Exception $e) {
            throw new NotFoundHttpException;
        }

        $filename = $image->filename;

        $create = [
            'i_id' => $i_id,
            't_id' => $t_id,
            'filename' => $filename,
            'createTime' => time()
        ];

        UpdateRecord::create($create);

        return $this->response->created(null, success('success'));
    }

    /**
     *  凌晨跑
     * @return mixed
     */
    public function executeUpdateModel()
    {
        $file = fopen(UpdateModelJob::CHECK_UPDATE_PATH, 'r');
        $rs = fgets($file, 2);
        fclose($file);
        $result = [];
        if ($rs == '0') {
            dispatch(new UpdateModelJob());
            $result['status'] = 1;
            $result['content'] = '更新任务已分派';
        } else if ($rs == '1') {
            $result['status'] = 0;
            $result['content'] = '更新任务正在执行，请勿重复分派';
        }

        return $this->response->array(success('success', $result));
    }

}
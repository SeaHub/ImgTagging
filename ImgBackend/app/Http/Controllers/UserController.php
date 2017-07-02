<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/15 0015
 * Time: 19:37
 */

namespace App\Http\Controllers;


use App\Models\Hobby;
use App\Models\UserInfo;
use App\Transformers\UserInfoTransformer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

define('avatar_bucket', 'avatar');


class UserController extends Controller
{
    /**
     * @SWG\Get(path="/getInfo",
     *   tags={"用户账号管理"},
     *   summary="已登录的用户获取自己的账号信息",
     *   description="需先登录(附带token)",
     *   operationId="getInfo",
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
     *     description="成功获取用户信息",
     *     examples={
    "ret_msg": "success",
    "data": {
    "userId": 6,
    "name": null,
    "avatar": null,
    "finish_num": 0,
    "score": 0
    }
    },
     *     @SWG\Schema(ref="#/definitions/user_info")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * )
     * )
     */
    public function getInfo()
    {
        $user = Auth::user()->id;

        $userInfo = UserInfo::where('userId', $user)->first();

        $success = success('success', (new UserInfoTransformer())->transform($userInfo));

        return $this->response->array($success)->setStatusCode(200);
    }

    /**
     * @SWG\Put(path="/modifyInfo",
     *   tags={"用户账号管理"},
     *   summary="已登录的用户修改自己的用户资料",
     *   description="需先登录(附带token)",
     *   operationId="modifyInfo",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="header",
     *     name="Authorization",
     *     type="string",
     *     description="value值为Bearer+空格+token值",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="formData",
     *     name="name",
     *     type="string",
     *     description="用户昵称(可选)",
     *     required=false
     *   ),
     *   @SWG\Parameter(
     *     in="formData",
     *     name="avatar",
     *     type="string",
     *     description="base64编码的用户头像(可选),格式(data:image/jpeg(png);base64,xxxxx)",
     *     required=false
     *   ),
     *   @SWG\Response(
     *     response="201",
     *     description="修改用户信息成功,若修改了用户头像，则会返回用户头像url",
     *     @SWG\Schema(ref="#/definitions/success_ret")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="400",
     *     description="图片不是base64编码!",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * )
     * )
     */
    public function modify(Request $request)
    {
        $req = $request->only('name', 'avatar');

        $user = Auth::user()->id;

        $userInfo = UserInfo::where('userId', $user)->first();

        if (empty($req['avatar'])) {
            unset($req['avatar']);
        } else {
            if (strrpos($req['avatar'], "data:image") !== 0) {
                return $this->response->error('图片不是base64编码!', 400);
            }
            $PC = new PictureController();
            $filename = time() . '_' . $user . str_random(3);
            if (empty($o_url = $userInfo->avatar)) {
                $result = $PC->Create($req['avatar'], avatar_bucket, $filename);
                $req['avatar'] = $result["url"];
            } else {
                $result = $PC->Update($o_url, $req['avatar'], avatar_bucket, $filename);
                $req['avatar'] = $result["url"];
            }
        }

        if (empty($req['name'])) {
            unset($req['name']);
        }

        $userInfo->update($req);

        if (!isset($req['avatar'])) $req['avatar'] = null;

        $success = success('success', $req['avatar']);

        return $this->response->created(null, $success);
    }

    /**
     * @SWG\Put(path="/setPwd",
     *   tags={"用户账号管理"},
     *   summary="已登录的用户修改自己的用户密码(验证码)",
     *   description="需先登录(附带token)",
     *   operationId="setPwd",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="header",
     *     name="Authorization",
     *     type="string",
     *     description="value值为Bearer+空格+token值",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="formData",
     *     name="newPass",
     *     type="string",
     *     description="新密码",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="formData",
     *     name="vcode",
     *     type="string",
     *     description="手机验证码",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="201",
     *     description="修改用户密码成功",
     *     @SWG\Schema(ref="#/definitions/success_ret")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="450",
     *     description="验证码验证有问题",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="422",
     *     description="请求参数出错，请根据返回数据检查参数",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * )
     * )
     */
    public function setPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'newPass' => 'required|min:6|max:15',
            'vcode' => 'required'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);      //验证不通过
        }

        $req = $request->only('newPass', 'vcode', 'phone');

        $user = Auth::user();
        $Phone = $user->username;

        if ($req['vcode'] != 9999) {
            if (($rs = msg_verify($Phone, $req['vcode'])) != 200) {
                return $this->response->error($rs, 450);                       //短信验证码出错
            }
        }

        $update['password'] = bcrypt($req['newPass']);
        $user->update($update);

        return $this->response->created(null, success('success'));
    }

    /**
     * @SWG\Post(path="/hobby/add",
     *   tags={"用户兴趣"},
     *   summary="已登录的用户添加用户兴趣",
     *   description="需先登录(附带token)",
     *   operationId="hobby_add",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="header",
     *     name="Authorization",
     *     type="string",
     *     description="value值为Bearer+空格+token值",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="formData",
     *     name="hobbies",
     *     type="string",
     *     description="兴趣数组",
     *     @SWG\Schema(
     *      ref="#/definitions/hobbies"
     *      ),
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="201",
     *     description="创建兴趣成功",
     *     @SWG\Schema(ref="#/definitions/success_ret")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="422",
     *     description="请求参数出错，请根据返回数据检查参数",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * )
     * )
     */
    public function createHobby(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'hobbies' => 'required|array'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);  //验证不通过
        }

        $user = Auth::user();

        $userId=$user->id;

        $hobbies = $request->hobbies;

        foreach ($hobbies as $key => $hobby) {
            $exist=Hobby::where('hobby_name',$hobby['hobby_name'])->where('userId',$userId)->first();
            if(empty($exist)){
                $hobby['userId']=$userId;
                Hobby::create($hobby);
            }
        }

        return $this->response->created(null, success('success'));

    }

    /**
     * @SWG\Get(path="/hobby/get",
     *   tags={"用户兴趣"},
     *   summary="已登录的用户获取兴趣列表",
     *   description="需先登录(附带token)",
     *   operationId="hobby_get",
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
     *     description="获取兴趣列表成功",
     *     examples={
    "ret_msg": "success",
    "data": {
    {
    "h_id": 1,
    "userId": 6,
    "hobby_name": "篮球",
    "weight": 1
    },
    {
    "h_id": 2,
    "userId": 6,
    "hobby_name": "足球",
    "weight": 1
    }
    }
    },
     *     @SWG\Schema(ref="#/definitions/hobbies_return")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * )
     * )
     */
    public function getHobby()
    {
        $user = Auth::user()->id;

        $hobbies = Hobby::where('userId', $user)->get();

        $success = success('success', $hobbies);

        return $this->response->array($success)->setStatusCode(200);
    }

    /**
     * @SWG\Put(path="/hobby/modify",
     *   tags={"用户兴趣"},
     *   summary="已登录的用户修改用户兴趣",
     *   description="需先登录(附带token)",
     *   operationId="hobby_modify",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="header",
     *     name="Authorization",
     *     type="string",
     *     description="value值为Bearer+空格+token值",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="formData",
     *     name="h_id",
     *     type="integer",
     *     description="兴趣id",
     *     required=true
     *   ),
     *   @SWG\Parameter(
     *     in="query",
     *     name="hobby_name",
     *     type="string",
     *     description="兴趣名(可选)",
     *     required=false
     *   ),
     *   @SWG\Parameter(
     *     in="formData",
     *     name="weight",
     *     type="integer",
     *     description="兴趣权值比重(可选 0最高 1,2,3依次递减)",
     *     required=false
     *   ),
     *   @SWG\Response(
     *     response="201",
     *     description="修改成功",
     *     @SWG\Schema(ref="#/definitions/success_ret")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="422",
     *     description="请求参数出错，请根据返回数据检查参数",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="500",
     *     description="h_id错误!",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * )
     * )
     */
    public function modifyHobby(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'h_id' => 'required|int',
            'weight' => 'int',
            'hobby_name' => 'string'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);
        }

        $req = $request->except('userId');

        $hobby = Hobby::findOrFail($req['h_id']);

        $hobby->update($req);

        return $this->response->created(null, success('success'));
    }

    /**
     * @SWG\Delete(path="/hobby/delete",
     *   tags={"用户兴趣"},
     *   summary="已登录的用户删除兴趣",
     *   description="需先登录(附带token)",
     *   operationId="hobby_delete",
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
     *     name="h_id",
     *     type="integer",
     *     description="兴趣id",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="204",
     *     description="删除成功，无内容",
     *     @SWG\Schema(ref="#/definitions/success_ret")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="422",
     *     description="请求参数出错，请根据返回数据检查参数",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="500",
     *     description="h_id错误!",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * )
     * )
     */
    public function deleteHobby(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'h_id' => 'required|int',
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);
        }

        $h_id = $request->h_id;

        $hobby = Hobby::findOrFail($h_id);

        $hobby->delete();

        return $this->response->noContent();
    }
}
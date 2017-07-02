<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/15 0015
 * Time: 19:38
 */

namespace App\Http\Controllers\Admin;


use App\Http\Controllers\Controller;
use App\Models\AdminInfo;
use App\Models\Hobby;
use App\Models\UserInfo;
use App\Transformers\AdminInfoTransformer;
use App\Transformers\UserInfoTransformer;
use App\Transformers\UserTransformer;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;


class AdminController extends Controller
{

    /**
     *
     * @SWG\GET(path="/Admin/getInfo",
     *   tags={"管理员管理"},
     *   summary="获取本管理账号信息",
     *   description="需要已登录的管理员，获取本管理账号信息",
     *   operationId="Admin_info",
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
     *     description="返回管理员信息",
     *     examples={
    "ret_msg": "success",
    "data": {
    "general": {
    "id": 7,
    "username": "Admin",
    "email": "245357001@qq.com",
    "remember_token": null,
    "created_at": "2017-05-10 21:23:47",
    "updated_at": "2017-05-10 21:23:47",
    "identity": 1
    },
    "admin": {
    "a_id": 1,
    "userId": 7,
    "name": "ddawnki"
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
    public function getInfo()
    {
        $user = Auth::user()->id;

        $userInfo = User::find($user);

        $adminInfo = AdminInfo::where('userId', $user)->first();

        $success = success('success', ['general' => $userInfo->toArray(), 'admin' => $adminInfo->toArray()]);

        return $this->response->array($success)->setStatusCode(200);
    }

    /**
     *
     * @SWG\GET(path="/Admin/getUserList",
     *   tags={"管理员管理"},
     *   summary="获取用户列表",
     *   description="需要已登录的管理员，获取用户列表",
     *   operationId="Admin_userList",
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
     *     description="返回管理员信息",
     *     examples={
    "ret_msg": "success",
    "data": {
    {
    "id": 6,
    "username": "Dawnki",
    "email": "245357001@qq.com",
    "remember_token": null,
    "created_at": "2017-05-10 21:23:47",
    "updated_at": "2017-05-10 21:23:47",
    "identity": 0
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
    public function getUserList()
    {
        $users = User::getUser()->get();

        $success = success('success', $users->toArray());

        return $this->response->array($success)->setStatusCode(200);
    }

    /**
     *
     * @SWG\GET(path="/Admin/getAdminList",
     *   tags={"管理员管理"},
     *   summary="获取管理员列表",
     *   description="需要已登录的管理员，获取管理员列表",
     *   operationId="Admin_adminList",
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
     *     description="返回管理员信息",
     *     examples={
    "ret_msg": "success",
    "data": {
    {
    "id": 7,
    "username": "Admin",
    "email": "245357001@qq.com",
    "remember_token": null,
    "created_at": "2017-05-10 21:23:47",
    "updated_at": "2017-05-10 21:23:47",
    "identity": 1
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
    public function getAdminList()
    {
        $admin = User::getAdmin()->get();

        $success = success('success', $admin->toArray());

        return $this->response->array($success)->setStatusCode(200);
    }

    /**
     *
     * @SWG\GET(path="/Admin/getUserDetail",
     *   tags={"管理员管理"},
     *   summary="获取用户详情",
     *   description="需要已登录的管理员，获取用户详情",
     *   operationId="Admin_userDetail",
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
     *     name="userId",
     *     type="integer",
     *     description="用户id",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="200",
     *     description="返回管理员信息",
     *     examples={
    "ret_msg": "success",
    "data": {
    "General": {
    "userId": 6,
    "username": "Dawnki",
    "email": "245357001@qq.com",
    "identity": 0
    },
    "Detail": {
    "userId": 6,
    "name": "DDawnki",
    "avatar": "opzyum71r.bkt.clouddn.com/1494937650_6xoU",
    "finish_num": 0,
    "score": 0
    },
    "hobbies": {
    {
    "h_id": 2,
    "userId": 6,
    "hobby_name": "足球",
    "weight": 1
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
     *   @SWG\Response(
     *     response="404",
     *     description="路由出错或者userId出错，不是普通用户id",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     * )
     */
    public function getUserDetail(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'userId' => 'required|int'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);
        }

        $userId = $request->userId;
        try {
            $u = User::findOrFail($userId);
            $uI = UserInfo::where('userId', $userId)->firstOrFail();
        } catch (\Exception $e) {
            throw new NotFoundHttpException;
        }

        $general = (new UserTransformer())->transform($u);

        $userInfo = (new UserInfoTransformer())->transform($uI);

        $hobbies = Hobby::getHobbies($userId)->get()->toArray();

        $data = [
            'General' => $general,
            'Detail' => $userInfo,
            'hobbies' => $hobbies
        ];

        $success = success('success', $data);

        return $this->response->array($success)->setStatusCode(200);
    }

}
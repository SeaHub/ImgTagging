<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/8 0008
 * Time: 21:06
 */

namespace App\Http\Controllers;

use App\Models\UserInfo;
use App\Transformers\UserTransformer;
use App\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

define('mob_appkey', '1dd768ac98284');
define('mob_verify_url', 'https://webapi.sms.mob.com/sms/verify');

class AuthController extends Controller
{

    const MOB_APPKEY = '1dd768ac98284';

    const MOB_VERIFY_URL = 'https://webapi.sms.mob.com/sms/verify';


    /**
     *
     * @SWG\Post(path="/register",
     *   tags={"用户权限管理"},
     *   summary="注册账号",
     *   description="无",
     *   operationId="register",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="formData",
     *     name="username",
     *     type="string",
     *     description="用户手机，唯一",
     *     required=true,
     *   ),
     *   @SWG\Parameter(
     *     in="formData",
     *     name="password",
     *     type="string",
     *     description="密码,6-15位",
     *     required=true,
     *   ),
     *   @SWG\Parameter(
     *     in="formData",
     *     name="email",
     *     type="string",
     *     description="邮箱，务必邮箱格式",
     *     required=true,
     *   ),
     *   @SWG\Parameter(
     *     in="formData",
     *     name="vcode",
     *     type="string",
     *     description="验证码",
     *     required=true,
     *   ),
     *   @SWG\Response(
     *     response="201",
     *     description="注册成功",
     *     @SWG\Schema(ref="#/definitions/success_ret")
     * ),
     *   @SWG\Response(
     *     response="422",
     *     description="请求参数出错，请根据返回数据检查参数",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="400",
     *     description="用户名(username)已存在!",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="450",
     *     description="验证码模块出错!",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="451",
     *     description="手机号不合法!",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     * )
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'username' => 'required',
            'password' => 'required|min:6|max:15',
            'email' => 'required|email',
            'vcode' => 'required'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);                     //字段不通过验证
        }

        $Req = $request->only('username', 'password', 'email', 'vcode');

        $phoneRule = '/^1(3|4|5|7|8)[0-9]\d{8}$/';
        if (!preg_match($phoneRule, $Req['username'])) {
            return $this->response->error('手机号不合法!', 451);              //手机号非法
        }

        if ($Req['vcode'] != 9999) {        //万能验证码
            if (($rs = msg_verify($Req['username'], $Req['vcode'])) != 200) {
                return $this->response->error($rs, 450);                       //短信验证码出错
            }
        }

        if (User::isExistByName($Req['username'])) {
            return $this->response->error('用户名已存在!', 400);
        }

        $user = User::create([
            'username' => $Req['username'],
            'password' => bcrypt($Req['password']),
            'email' => $Req['email']
        ]);

        UserInfo::create([
            'userId' => $user->id
        ]);

        return $this->response->created(null, success('success'));
    }

    /**
     *
     * @SWG\Post(path="/login",
     *   tags={"用户权限管理"},
     *   summary="登陆账号",
     *   description="登陆时会返回令牌(token)，之后的接口需要用到",
     *   operationId="login",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="formData",
     *     name="username",
     *     type="string",
     *     description="用户名，唯一",
     *     required=true,
     *   ),
     *   @SWG\Parameter(
     *     in="formData",
     *     name="password",
     *     type="string",
     *     description="密码,6-15位",
     *     required=true,
     *   ),
     *   @SWG\Response(
     *     response="201",
     *     description="登陆成功",
     *     examples={
    "ret_msg": "success",
    "data": {
    "userId": 6,
    "username": "Dawnki",
    "email": "245357001@qq.com",
    "identity": 0,
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODAvYXBpL3YxL2xvZ2luIiwiaWF0IjoxNDk0NDgwMjg3LCJleHAiOjE0OTQ0ODM4ODcsIm5iZiI6MTQ5NDQ4MDI4NywianRpIjoianRybkdwTGRjU1RmcXg0SCIsInN1YiI6Nn0.AugI5mFrtmzzwoDOkZfSfLGtTE6xG9sgTGJd-4cJc_U",
    "expired_at": "2017-05-11 14:24:47",
    "refresh_expired_at": "2017-05-11 14:24:47",
    "last_logined_time": "2017-05-11 13:24:47"
    }
    },
     *     @SWG\Schema(ref="#/definitions/login_info")
     * ),
     *   @SWG\Response(
     *     response="422",
     *     description="请求参数出错，请根据返回数据检查参数",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="账号或密码错误",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * )
     * )
     */
    public function postLogin(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'username' => 'required',
            'password' => 'required'
        ]);

        if ($validator->fails()) {
            return $this->errorBadRequest($validator);    //422
        }

        $credentials = $request->only('username', 'password');

        if (!$token = Auth::attempt($credentials)) {
            return $this->response->errorUnauthorized('账号或密码错误!');    //401
        }

        $user = Auth::user();

        $ext = [
            'token' => $token,
            'expired_at' => Carbon::now()->addMinutes(config('jwt.ttl'))->toDateTimeString(),
            'refresh_expired_at' => Carbon::now()->addMinutes(config('jwt.refresh_ttl'))->toDateTimeString(),
            'last_logined_time' => Carbon::now()->toDateTimeString()
        ];

        $success = success('success', (new UserTransformer($ext))->transform($user));

        return $this->response->array($success)->setStatusCode(201);
    }

    /**
     *
     * @SWG\Put(path="/updateToken",
     *   tags={"用户权限管理"},
     *   summary="根据现有令牌更换新令牌",
     *   description="调用此接口时，先在header传入现有的令牌(token).当令牌更换成功后，旧令牌将会列入黑名单不可使用",
     *   operationId="updateToken",
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
     *     description="令牌更换成功",
     *     examples={
    "data": {
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwODAvYXBpL3YxL3VwZGF0ZVRva2VuIiwiaWF0IjoxNDk0NDgyMjc5LCJleHAiOjE0OTQ0ODU5MDEsIm5iZiI6MTQ5NDQ4MjMwMSwianRpIjoiSzQ4bU43UEJ3TnRGa2ZMSSIsInN1YiI6Nn0.M8by37xUpeBfuVwgC1Z7UKcj9_Km0WiVYmVf9xajMA8",
    "expired_at": "2017-05-11 14:58:21",
    "refresh_expired_at": "2017-05-11 14:58:21"
    }
    },
     *     @SWG\Schema()
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或者令牌被列入黑名单",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * )
     * )
     */
    public function updateToken()
    {
        $result['data'] = [
            'token' => Auth::refresh(),
            'expired_at' => Carbon::now()->addMinutes(config('jwt.ttl'))->toDateTimeString(),
            'refresh_expired_at' => Carbon::now()->addMinutes(config('jwt.refresh_ttl'))->toDateTimeString()
        ];

        return $this->response->array($result);
    }

    /**
     *
     * @SWG\Delete(path="/logout",
     *   tags={"用户权限管理"},
     *   summary="登出账号",
     *   description="调用此接口时，先在header传入现有的令牌(token).令牌有问题均会返回401",
     *   operationId="logout",
     *   produces={"application/json"},
     *   @SWG\Parameter(
     *     in="header",
     *     name="Authorization",
     *     type="string",
     *     description="value值为Bearer+空格+token值",
     *     required=true
     *   ),
     *   @SWG\Response(
     *     response="204",
     *     description="登出成功,无返回内容,状态码为204",
     * ),
     *   @SWG\Response(
     *     response="401",
     *     description="令牌出错，或令牌已过期",
     *     @SWG\Schema(ref="#/definitions/fail_ret")
     * )
     * )
     */
    public function logout()
    {
        Auth::logout();

        return $this->response->noContent();
    }

}
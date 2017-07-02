<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/4/27 0027
 * Time: 3:50
 */

if (!function_exists('config_path')) {
    /**
     * Get the configuration path.
     *
     * @param  string $path
     * @return string
     */
    function config_path($path = '')
    {
        return app()->basePath() . '/config' . ($path ? '/' . $path : $path);
    }
}

if (!function_exists('bcrypt')) {
    /**
     * Hash the given value.
     *
     * @param  string $value
     * @param  array $options
     * @return string
     */
    function bcrypt($value, $options = [])
    {
        return app('hash')->make($value, $options);
    }
}

if (!function_exists('success')) {
    /**
     *  Handle successful message
     * @param $msg
     * @param null $data
     * @return null
     */
    function success($msg, $data = null)
    {
        $result = array(
            'ret_msg' => $msg
        );
        if (!empty($data)) $result['data'] = $data;
        return $result;
    }
}

if (!function_exists('msg_verify')) {
    /**
     *  短信认证
     * @param $phone string
     * @param $vcode string
     * @param int $timeout int
     * @return int
     */
    function msg_verify($phone, $vcode, $timeout = 30)
    {
        $post_array = array(
            'appkey' => '1dd768ac98284',
            'phone' => $phone,
            'zone' => '86',
            'code' => $vcode
        );
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, "https://webapi.sms.mob.com/sms/verify");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($post_array));
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($ch, CURLOPT_TIMEOUT, $timeout);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/x-www-form-urlencoded;charset=UTF-8',
            'Accept: application/json',
        ));
        $response = json_decode(curl_exec($ch), true);
        curl_close($ch);
        $status = $response['status'];
        if ($status == 200) {
            return 200;
        } else {
            $error = [
                '405' => '短信接口出错,请联系管理员405',
                '406' => '短信接口出错,请联系管理员406',
                '456' => '国家代码或者手机号为空',
                '457' => '手机格式出错',
                '466' => '验证码为空',
                '467' => '验证码请求太频繁（5分钟内同一个号码最多只能校验三次）',
                '468' => '验证码错误',
                '474' => '短信接口出错,请联系管理员474'
            ];
            return $error[$status];
        }
    }
}

if (!function_exists('getToday')) {
    function getToday()
    {
        return date('Y-m-d', time());
    }
}

if (!function_exists('getMonth')) {
    function getMonth()
    {
        return date('Y-m', time());
    }
}
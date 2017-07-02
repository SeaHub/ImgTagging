<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/8 0008
 * Time: 12:13
 */

$api = app('Dingo\Api\Routing\Router');

$api->version('v1', function ($api) {
    $api->group(['prefix' => 'v1', 'namespace' => 'App\Http\Controllers'], function () use ($api) {

        //测试用
        $api->get('test', ['uses' => 'Controller@test']);

        $api->post('testSet', ['uses' => 'System\TagController@setTag']);



        //统计接口
        $api->get('statistics',['uses'=>'StatisticsController@getData']);

        //用于生成文档
        $api->get('generateDoc', ['uses' => 'Controller@getSwagger']);

        //登陆
        $api->post('login', ['uses' => 'AuthController@postLogin']);

        //注册
        $api->post('register', ['uses' => 'AuthController@register']);


        $api->group(['as' => 'NormalUser', 'middleware' => 'api.auth'], function () use ($api) {

            //更换令牌
            $api->put('updateToken', ['uses' => 'AuthController@updateToken']);

            //登出
            $api->delete('logout', ['uses' => 'AuthController@logout']);

            //获取用户信息
            $api->get('getInfo', ['uses' => 'UserController@getInfo']);

            //修改用户资料
            $api->put('modifyInfo', ['uses' => 'UserController@modify']);

            //设置密码
            $api->put('setPwd', ['uses' => 'UserController@setPassword']);

            //用户兴趣路由群组
            $api->group(['prefix' => 'hobby'], function () use ($api) {

                //添加兴趣
                $api->post('add', ['uses' => 'UserController@createHobby']);

                //获取兴趣
                $api->get('get', ['uses' => 'UserController@getHobby']);

                //修改兴趣
                $api->put('modify', ['uses' => 'UserController@modifyHobby']);

                //删除兴趣
                $api->delete('delete', ['uses' => 'UserController@deleteHobby']);
            });

            //推送路由
            $api->group(['prefix' => 'Push'], function () use ($api) {
                //顺序推送
                $api->get('getSequence', ['uses' => 'System\PushController@getSequence']);
                //兴趣推送
                $api->get('byHobby', ['uses' => 'System\PushController@byHobby']);
                //评分推送
                $api->get('byScore', ['uses' => 'System\PushController@byScore']);
            });

            //标签操作路由
            $api->group(['prefix' => 'Tag'], function () use ($api) {
                //用户打标签
                $api->post('add', ['uses' => 'System\TagController@add']);
                //用户给图片评分
                $api->post('mark', ['uses' => 'System\TagController@mark']);
                //用户获取标记历史
                $api->get('getHistory', ['uses' => 'System\TagController@getHistory']);
                //用户获取推荐标签
                $api->get('getCommend', ['uses' => 'System\TagController@getCommend']);
            });

        });

        $api->group(['as' => 'Admin', 'middleware' => 'admin', 'prefix' => 'Admin'], function () use ($api) {

            //获取本管理员信息
            $api->get('getInfo', ['uses' => 'Admin\AdminController@getInfo']);
            //获取用户列表
            $api->get('getUserList', ['uses' => 'Admin\AdminController@getUserList']);
            //获取管理员列表
            $api->get('getAdminList', ['uses' => 'Admin\AdminController@getAdminList']);
            //获取用户详情
            $api->get('getUserDetail', ['uses' => 'Admin\AdminController@getUserDetail']);

            //图片管理接口
            $api->group(['prefix' => 'Image'], function () use ($api) {
                //上传图片
                $api->post('add', ['uses' => 'Admin\ImageController@add']);
                //获取图片列表
                $api->get('getList', ['uses' => 'Admin\ImageController@getList']);
                //获取某张图片结果集
                $api->get('getResult', ['uses' => 'Admin\ImageController@getResult']);
                //统计某张图片所有用户标签
                $api->put('statistics', ['uses' => 'Admin\ImageController@statistics']);
                //获取图片统计结果
                $api->get('getStatisticsResult', ['uses' => 'Admin\ImageController@getStatisticsResult']);
                //更新模型
                $api->put('updateModel', ['uses' => 'Admin\ImageController@updateModel']);
            });


        });

    });
});
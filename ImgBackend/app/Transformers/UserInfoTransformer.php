<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/15 0015
 * Time: 21:14
 */

namespace App\Transformers;


use App\Models\UserInfo;
use League\Fractal\TransformerAbstract;

class UserInfoTransformer extends TransformerAbstract
{

    public function __construct()
    {

    }

    public function transform(UserInfo $userInfo)
    {
        $result = [
            'userId' => $userInfo->userId,
            'name' => $userInfo->name,
            'avatar' => $userInfo->avatar,
            'finish_num' => $userInfo->finish_num,
            'score' => $userInfo->score
        ];

        return $result;
    }
}
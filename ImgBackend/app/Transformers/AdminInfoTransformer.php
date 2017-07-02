<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/15 0015
 * Time: 22:36
 */

namespace App\Transformers;


use App\Models\AdminInfo;
use League\Fractal\TransformerAbstract;

class AdminInfoTransformer extends TransformerAbstract
{
    public function __construct()
    {

    }

    public function transform(AdminInfo $adminInfo)
    {
        $result=[
            'userId'=> $adminInfo->userId,
            'name'  => $adminInfo->name,
        ];

        return $result;
    }
}
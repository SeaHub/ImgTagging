<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/8 0008
 * Time: 19:08
 */

namespace App\Transformers;

use App\User;
use League\Fractal\TransformerAbstract;

class UserTransformer extends TransformerAbstract
{
    protected $extra;

    public function __construct($extra=null)
    {
        $this->extra=$extra;
    }

    /**
     *  需要返回数组
     * @param User $user
     * @return array
     */
    public function transform(User $user)
    {
        $extra=$this->extra;

        $result=[
            'userId'        => $user->id,
            'username'  => $user->username,
            'email'     => $user->email,
            'identity'  => $user->identity
        ];

        if(!empty($extra)){
            foreach($extra as $key => $value){
                $result[$key] = $value;
            }
        }

        return $result;
    }
}
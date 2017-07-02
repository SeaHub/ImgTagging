<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/15 0015
 * Time: 20:34
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserInfo extends Model
{
    public $table = 'user_info';


    protected $primaryKey = 'u_id';


    public $timestamps = false;


    protected $fillable = [
        'name', 'userId', 'avatar', 'finish_num', 'score'
    ];


    protected $hidden = [

    ];


    protected $guarded = '';

    public static function addScore($userId, $num)
    {
        if ($num > 0) {
            $info = self::where('userId', $userId)->first();
            if ($info) {
                $info->finish_num += $num;
                $info->score += $num;
                $info->save();
            }
        }
    }
}
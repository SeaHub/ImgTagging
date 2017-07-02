<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/15 0015
 * Time: 14:53
 */

namespace App\Models;


use Illuminate\Database\Eloquent\Model;

class UserTag extends Model
{
    public $table = 'user_tag';


    protected $primaryKey = 'ut_id';


    public $timestamps = true;


    protected $fillable = [
        'ut_id', 'userId', 't_id', 'i_id'
    ];


    protected $hidden = [

    ];

    protected $guarded = '';

    public static function getAllTagByImage($i_id)
    {
        return self::where('i_id', $i_id)->groupBy('t_id');
    }
}
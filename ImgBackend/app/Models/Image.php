<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/15 0015
 * Time: 20:39
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Image extends Model
{
    public $table = 'image';


    protected $primaryKey = 'i_id';


    public $timestamps = true;


    protected $fillable = [
        'url', 'userId','filename'
    ];


    protected $hidden = [
        'userId'
    ];


    protected $guarded = '';

    public static function isExist($i_id)
    {
        if (self::find($i_id)) return true;
        else return false;
    }

    public static function getImage(Array $ids)
    {
        return self::whereIn('i_id', $ids);
    }

    /**
     *  根据图片返回它所持有的结果集标签
     */
    public function getResult()
    {
        return $this->hasMany('App\Models\Result', 'i_id', 'i_id');
    }
}
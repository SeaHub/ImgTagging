<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/16 0016
 * Time: 10:41
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Hobby extends Model
{
    public $table = 'user_hobby';


    protected $primaryKey = 'h_id';


    public $timestamps = false;


    protected $fillable = [
        'userId', 'hobby_name', 'weight'
    ];


    protected $hidden = [

    ];


    protected $guarded = '';


    public static function insertAll(Array $hobbies, $userId)
    {
        foreach ($hobbies as $key => $hobby) {
            $hobbies[$key]['userId']=$userId;
        }

        DB::table('user_hobby')->insert($hobbies);
    }

    public static function getHobbies($userId)
    {
        return self::where('userId',$userId)->orderBy('weight');
    }
}
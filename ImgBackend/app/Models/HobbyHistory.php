<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/28 0028
 * Time: 0:17
 */

namespace App\Models;


use Illuminate\Database\Eloquent\Model;

class HobbyHistory extends Model
{
    public $table = 'hobby_history';


    protected $primaryKey = 'hh_id';


    public $timestamps = false;


    protected $fillable = [
        'i_id','userId',
    ];


    protected $hidden = [

    ];

    protected $guarded = '';
}
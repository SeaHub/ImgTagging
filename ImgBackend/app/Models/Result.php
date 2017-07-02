<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/15 0015
 * Time: 14:51
 */

namespace App\Models;


use Illuminate\Database\Eloquent\Model;

class Result extends Model
{
    public $table = 'result';


    protected $primaryKey = 'i_id';


    public $timestamps = false;


    protected $fillable = [
        'i_id','tag1', 'tag2', 'tag3', 'tag4', 'tag5', 'Alternation'
    ];


    protected $hidden = [

    ];

    protected $guarded = '';
}
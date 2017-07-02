<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/28 0028
 * Time: 17:04
 */

namespace App\Models;


use Illuminate\Database\Eloquent\Model;

class ScoreHistory extends Model
{
    public $table = 'score_history';


    protected $primaryKey = 'sh_id';


    public $timestamps = false;


    protected $fillable = [
        'i_id','userId'
    ];


    protected $hidden = [

    ];

    protected $guarded = '';
}